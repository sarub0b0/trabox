# Trabox Example

## Prepare

### Middleware

```sh
docker run --rm -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name=mysql mysql:5.7
```

```sh
gcloud beta emulators pubsub start
```

```sh
./setup.sh
```

### Relayer

```sh
cd relayer
bin/trabox relay

```

### Subscriber

```sh
cd subscriber
bin/trabox subscriber
```
