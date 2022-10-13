# Octank User Micro Service


## Build Docker

```
make run
```

## Run Docker

```
$ cat start_docker.sh
#!/bin/bash

export image=octank-user:latest
export dbhost=<dbhost>
export dbuser=octankuser
export dbpass=oktadmin
export dbname=octankdb
export echost="<echosts>"
export secret_key=krishna
export dbport=5432

docker run  -dti --rm --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201 \
                 --name octankuser -p 8446:8446  \
                 -e DATABASE_HOST=$dbhost \
                 -e DATABASE_USER=$dbuser \
                 -e DATABASE_PASSWORD=$dbpass  \
                 -e DATABASE_DB_NAME=$dbname \
                 -e ECHOST=$echost  \
                 -e SECRET_KEY=$secret_key \
                 -e DATABASE_PORT=$dbport \
                 $image
```
