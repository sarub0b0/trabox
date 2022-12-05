#!/bin/bash

set -e

(
    cd ./relayer;
    bin/rails db:drop;
    bin/rails db:create
    bin/rails db:migrate
)

(
    cd ./subscriber
    bin/rails db:drop
    bin/rails db:create
    bin/rails db:migrate
)

export GOOGLE_AUTH_SUPPRESS_CREDENTIALS_WARNINGS=1

export GOOGLE_CLOUD_PROJECT=trabox
export PUBSUB_EMULATOR_HOST=localhost:8085


../bin/setup-pubsub
