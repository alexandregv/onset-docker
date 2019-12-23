# onset-docker
Onset game server dockerized.  
Check it on the [DockerHub](https://hub.docker.com/r/alexandregv/onset-server).  

### Basic usage
`docker run -d -p 7777:7777/udp -p 7776:7776/udp -p 7775:7775/tcp alexandregv/onset-server`  

Add `-v $PWD/server_config.json:/Steam/OnsetServer/server_config.json` to import your [server configuration file](https://dev.playonset.com/wiki/server_config).  
