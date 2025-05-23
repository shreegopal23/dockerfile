docker pull logicwind/appsonair-graphql-server-v2:dev
docker-compose -f docker-compose-server.yml down
docker-compose -f docker-compose-server.yml up -d
docker image prune -f