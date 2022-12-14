# Trabox Example

## Setup middlewares

```bash
docker run --rm -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes --name=mysql mysql:5.7
```

```bash
gcloud beta emulators pubsub start

# or

docker run --rm -p 8085:8085 google/cloud-sdk gcloud beta emulators pubsub start --host-port=0.0.0.0:8085
```

```bash
./setup.sh
```

### Running relayer

```bash
$ cd relayer
$ in/trabox relay
# stdout
I, [2022-12-14T16:16:35.989306 #26802]  INFO -- : Published events. (event=0)
I, [2022-12-14T16:16:41.021746 #26802]  INFO -- : Published events. (event=0)
I, [2022-12-14T16:16:46.243502 #26802]  INFO -- : Published events. (event=1)
```

#### Create event record

example

```irb
$ cd relayer
$ bin/rails c
Loading development environment (Rails 6.1.7)
irb(main):001:0> Event.create! event_data: 1
D, [2022-12-14T16:16:42.223524 #27267] DEBUG -- :   TRANSACTION (1.0ms)  BEGIN
D, [2022-12-14T16:16:42.226675 #27267] DEBUG -- :   Event Create (2.7ms)  INSERT INTO `events` (`event_data`, `created_at`, `updated_at`) VALUES (x'31', '2022-12-14 07:16:42.214522', '2022-12-14 07:16:42.214522')
D, [2022-12-14T16:16:42.230336 #27267] DEBUG -- :   TRANSACTION (1.9ms)  COMMIT
=>
#<Event:0x0000000106a9a1f8
 id: 1,
 event_data: "1",
 message_id: nil,
 published_at: nil,
 created_at: Wed, 14 Dec 2022 07:16:42.214522000 UTC +00:00,
 updated_at: Wed, 14 Dec 2022 07:16:42.214522000 UTC +00:00>
irb(main):002:0>
```

### Running subscriber

```bash
$ cd subscriber
$ bin/trabox subscriber
# stdout
I, [2022-12-14T16:16:15.538208 #26977]  INFO -- : Subscription 'trabox-sub': message ordering is true.
I, [2022-12-14T16:16:15.831054 #26977]  INFO -- : Listening subscrition...
I, [2022-12-14T16:16:46.260150 #26977]  INFO -- : id=1 message=1 ordering_key=Event
```
