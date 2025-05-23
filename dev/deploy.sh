docker pull image name :dev
docker-compose -f docker-compose-server.yml down
docker-compose -f docker-compose-server.yml up -d
docker image prune -f