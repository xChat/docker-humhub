# docker-humhub

Based on the latest ubuntu docker image at the time of build

Humhub
A social network without Big Brother

## How to

Just build it ...

```docker build -t xchat/docker-humhub .```

... run it ...

```docker run --name humhub -d xchat/docker-humhub && docker inspect humhub |grep IPAddress```

enjoy it ! `https://your-container-ip/`

## Variables, and default values
```shell
GIT_MASTER_URL https://github.com/humhub/humhub/archive/master.zip
DB_ROOT_PASSWORD boDlyGo!
DB_DATABASE humhub
DB_USER humhub
DB_PASSWORD _HuMhUb!
```

Based on:

https://hub.docker.com/r/adminrezo/docker-humhub (adminrezo/docker-humhub)

https://github.com/13Genius/docker-humhub

https://github.com/RobLoach/Dockie
