cd harvest/web-player/

rm src/config.json || true

printf "{ " >> src/config.json
printf "\"HARVESTER_API_URL\": \"$harvest_api_url\" \n" >> src/config.json
printf " }" >> src/config.json

npm install
npm run build