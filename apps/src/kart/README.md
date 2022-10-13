# Octank Kart Micro Service


## Build Docker

```
make run
```

## Run Docker

```
$ cat start_docker.sh
#!/bin/bash

export image=octank-kart:latest
export dbhost=<dbhost>
export dbuser=octankuser
export dbpass=oktadmin
export dbname=octankdb
export echost="<echosts>"
export secret_key=krishna
export dbport=5432

docker run  -dti --rm --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201 \
                 --name octankkart -p 8445:8445  \
                 -e DATABASE_HOST=$dbhost \
                 -e DATABASE_USER=$dbuser \
                 -e DATABASE_PASSWORD=$dbpass  \
                 -e DATABASE_DB_NAME=$dbname \
                 -e ECHOST=$echost  \
                 -e SECRET_KEY=$secret_key \
                 -e DATABASE_PORT=$dbport \
                 $image
```
