# onset-docker
Onset game server dockerized.  
Check it on the [DockerHub](https://hub.docker.com/r/alexandregv/onset-server).  

## Usage (docker-compose)
Just run `docker-compose up -d`. Make sure you have a [server_config.json](https://dev.playonset.com/wiki/server_config).  
You can check the logs with `docker-compose logs -f server`.

## Usage (docker only)
If you don't want to use docker-compose, you can run it directly with `docker run -d -p 7777:7777/udp -p 7776:7776/udp -p 7775:7775/tcp -v $PWD/packages:/Steam/OnsetServer/packages --name onset alexandregv/onset-server`.  
Add `-v $PWD/server_config.json:/Steam/OnsetServer/server_config.json` to import your [server configuration file](https://dev.playonset.com/wiki/server_config).  
You can check the logs with `docker logs -f onset`.  
