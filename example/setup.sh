#!/bin/bash

set -e

(
    cd ./relayer;
    bin/rails db:drop;
    bin/rails db:create
    bin/rails db:migrate

    rake pubsub:setup
)

(
    cd ./subscriber
    bin/rails db:drop
    bin/rails db:create
    bin/rails db:migrate
)
