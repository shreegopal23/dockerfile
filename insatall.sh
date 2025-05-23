set -o errexit
set -o nounset

IFS=$(printf '\n\t')

if [[ $(which docker) && $(docker --version) ]]; then
    echo "DOCKER IS ALREADY INSTALLED...!"
  else
    echo "Installing docker..."
    # command
    sudo apt update
    sudo apt --yes --no-install-recommends install apt-transport-https ca-certificates
    wget --quiet --output-document=- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release --codename --short) stable"
    sudo apt update
    sudo apt --yes --no-install-recommends install docker-ce docker-ce-cli containerd.io
    sudo usermod --append --groups docker "$USER"
    sudo chmod 666 /var/run/docker.sock
    sudo systemctl enable docker
    printf '\nDocker installed successfully\n\n'

    printf 'Waiting for Docker to start...\n\n'
    sleep 5
fi

if [[ $(which docker-compose) && $(docker-compose --version) ]]; then
    echo "DOCKER-COMPOSE IS ALREADY INSTALLED...!"
  else
    echo "Installing docker compose..."
    # AMD 64
    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    # ARM 64
    # sudo curl -L --fail "https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    printf '\nDocker Compose installed successfully\n\n'
fi

sudo service docker start

DOCKER_NETWORK_NAME="traefik-net"

if [ ! "$(docker network ls | grep $DOCKER_NETWORK_NAME)" ]; then
  echo "Creating $DOCKER_NETWORK_NAME network ..."
  docker network create --driver bridge $DOCKER_NETWORK_NAME
else
  echo "$DOCKER_NETWORK_NAME network exists."
fi