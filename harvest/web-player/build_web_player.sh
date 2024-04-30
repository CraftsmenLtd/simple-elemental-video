cd harvest/web-player/

printf "{ " >> src/config.json
printf "\"HARVESTER_API_URL\": \"$harvest_api_url\", \n" >> src/config.json
printf " }" >> src/config.json

npm install --force
npm run build