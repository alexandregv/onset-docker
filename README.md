# onset-docker
Onset game server dockerized.  
Check it on the [DockerHub](https://hub.docker.com/r/alexandregv/onset-server).  

## Usage (docker-compose)
Just run `docker-compose up -d`.  
You can check the logs with `docker-compose logs -f server`.  
I added basic config files (\*.json) in the `volumes` section, you will have to add each file you want to save here.

### MySQL/MariaDB configuration
All the configuration lives in the `.env` file.
Run `cp sample.env .env` on Linux or `copy sample.env .env` on Windows to create this file, then edit it.  

## Usage (docker only)
If you don't want to use docker-compose, you can run it directly with `docker run -d -p 7777:7777/udp -p 7776:7776/udp -p 7775:7775/tcp --name onset alexandregv/onset-server`.  
You should add `-v` flags to import folders or files like [`server_config.json`](https://dev.playonset.com/wiki/server_config), `packages/`, etc.  
Exemple: `-v $PWD/server_config.json:/Steam/OnsetServer/server_config.json`  
You can check the logs with `docker logs -f onset`.  

