#!/bin/bash

set -e

(
    cd ./relayer;
    bin/rails db:drop;
    bin/rails db:prepare

    rake pubsub:setup
)

(
    cd ./subscriber
    bin/rails db:drop
    bin/rails db:prepare
)
