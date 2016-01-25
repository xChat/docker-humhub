# docker-humhub

Base on `adminrezo/docker-humhub` docker image
Base on `stilliard/pure-ftpd:hardened` docker image


Humhub
A social network without Big Brother

MariaDB is configured with a humhub database with a humhub user with a HuMhUb password

## Howto

Just build it ...

```docker build -t adminrezo/humhub .```

... run it ...

```docker run --name humhub -d adminrezo/humhub && docker inspect humhub |grep IPAddress```

enjoy it ! `https://your-container-ip/`

## Variables, and default values
```shell
GIT_MASTER_URL https://github.com/humhub/humhub/archive/master.zip
DB_DATABASE humhub
DB_USER humhub
DB_PASSWORD HuMhUb
```

Based on:
adminrezo/docker-humhub - https://hub.docker.com/r/adminrezo/docker-humhub/

https://github.com/13Genius/docker-humhub

https://github.com/RobLoach/Dockie
