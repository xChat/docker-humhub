# docker-humhub

Based on the latest ubuntu docker image at the time of build

Humhub
A social network without Big Brother

## How to
```docker build -t xchat/docker-humhub .```
```docker run --name humhub -d xchat/docker-humhub && docker inspect humhub | grep IPAddress```

`https://your-container-ip/`

## Variables, and default values
```shell
GIT_MASTER_URL https://github.com/humhub/humhub/archive/master.zip
ROOT_PASSWORD rboDlyGo!
DB_ROOT_PASSWORD dboDlyGo!
DB_DATABASE humhub
DB_USER humhub
DB_PASSWORD _HuMhUb!
```

Based on:

https://hub.docker.com/r/adminrezo/docker-humhub (adminrezo/docker-humhub)

https://github.com/13Genius/docker-humhub

https://docs.docker.com/engine/examples/running_ssh_service/
