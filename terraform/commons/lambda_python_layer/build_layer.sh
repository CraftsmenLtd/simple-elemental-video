ARTIFACT_DIR=${ARTIFACT_DIR:-$PWD}
REQUIREMENTS_PATH=${REQUIREMENTS_PATH:-$PWD}
ZIPFILE_NAME=${ZIPFILE_NAME:-layer}

echo "Python requirements path: $REQUIREMENTS_PATH"
echo "lambda Layers artifact directory: $ARTIFACT_DIR"

TARGET_DIR=$ARTIFACT_DIR/$ZIPFILE_NAME
echo "lambda layers requirements installation directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Download python requirements
pip install -r "$REQUIREMENTS_PATH" --target "$TARGET_DIR"/python

# Zipping lambda layers
(cd "$TARGET_DIR" && zip -r "$ARTIFACT_DIR"/"$ZIPFILE_NAME".zip ./* -x "*.dist-info*" -x "*__pycache__*" -x "*.egg-info")
rm -r "$TARGET_DIR"
echo "lambda layers Zipfile location: $ARTIFACT_DIR/$ZIPFILE_NAME.zip"