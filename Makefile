AWS_REGION?=eu-west-1
AWS_DEFAULT_REGION?=eu-west-1
AWS_CLI_IMAGE=amazon/aws-cli
RUNNER_IMAGE_NAME?=dev-image
DOCKER_BUILD_EXTRA_ARGS?=--build-arg="TERRAFORM_VERSION=1.8.2" --build-arg="NODE_MAJOR=20"
DOCKER_RUN_MOUNT_OPTIONS:=-v ${PWD}:/app -w /app
DOCKER_ENV=-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_DEFAULT_REGION -e AWS_REGION
FFMPEG_IMAGE=sakibstark11/ffmpeg

define get_output
	terraform output $(1)
endef

tf-init:
	terraform init -input=false

tf-plan-apply:
	terraform plan -input=false -out=tf-apply.out

tf-plan-destroy:
	terraform plan -input=false -out=tf-destroy.out --destroy

tf-apply:
	terraform apply -input=false tf-apply.out

tf-destroy:
	terraform apply -input=false tf-destroy.out

tf-fmt:
	terraform -chdir=terraform fmt -recursive


MEDIACONNECT_FLOW_ARN=$(shell $(call get_output,mediaconnect_flow_arn))
MEDIALIVE_CHANNEL_ID=$(shell $(call get_output,medialive_channel_id))
MEDIACONNECT_INGRESS_IP=$(shell $(call get_output,mediaconnect_ingress_ip))
MEDIACONNECT_INGEST_PORT=$(shell $(call get_output,mediaconnect_ingest_port))
MEDIAPACKAGE_HLS_ENDPOINT=$(shell $(call get_output, mediapackage_hls_endpoint))

start-pipeline:
	aws mediaconnect start-flow --flow-arn $(MEDIACONNECT_FLOW_ARN) --region $(AWS_REGION) --query "Status" --no-cli-pager
	aws medialive start-channel --channel-id $(MEDIALIVE_CHANNEL_ID) --region $(AWS_REGION) --query "State" --no-cli-pager
	aws mediaconnect wait flow-active --flow-arn $(MEDIACONNECT_FLOW_ARN) --region $(AWS_REGION)
	aws medialive wait channel-running --channel-id $(MEDIALIVE_CHANNEL_ID) --region $(AWS_REGION)

wait-%:
	sleep $*

stop-pipeline:
	aws mediaconnect stop-flow --flow-arn $(MEDIACONNECT_FLOW_ARN) --region $(AWS_REGION) --query "Status" --no-cli-pager
	aws medialive stop-channel --channel-id $(MEDIALIVE_CHANNEL_ID) --region $(AWS_REGION) --query "State" --no-cli-pager
	aws medialive wait channel-stopped --channel-id $(MEDIALIVE_CHANNEL_ID) --region $(AWS_REGION)
	aws mediaconnect wait flow-standby --flow-arn $(MEDIACONNECT_FLOW_ARN) --region $(AWS_REGION)

start-streaming:
	docker run -itd --rm ${FFMPEG_IMAGE} -f lavfi -i testsrc=size=1920x1080:rate=25 -f lavfi -re -i sine=frequency=1000:sample_rate=44010 -f mpegts srt://$(MEDIACONNECT_INGRESS_IP):$(MEDIACONNECT_INGEST_PORT)

print-hls-playback-url:
	echo https://hlsjs.video-dev.org/demo/?src=$(MEDIAPACKAGE_HLS_ENDPOINT)

# Docker dev environment
build-runner-image:
	docker build -t $(RUNNER_IMAGE_NAME) $(DOCKER_BUILD_EXTRA_ARGS) .

run-command-%:
	docker run --rm $(DOCKER_RUN_MOUNT_OPTIONS) $(DOCKER_ENV) $(RUNNER_IMAGE_NAME) make $* EXTRA_ARGS=$(EXTRA_ARGS)

# Dev commands
start-dev: build-runner-image deploy

deploy: run-command-tf-init run-command-tf-plan-apply run-command-tf-apply

stream: run-command-start-pipeline wait-10 start-streaming print-hls-playback-url

destroy: run-command-tf-init run-command-tf-plan-destroy run-command-tf-destroy run-command-stop-pipeline
