#!/bin/bash

"$KAFKA_HOME"/bin/kafka-server-start.sh -daemon  config/server.properties
"$KAFKA_HOME"/bin/kafka-topics.sh --create --zookeeper "$KAFKA_HOST":"$KAFKA_PORT" --replication-factor 1 --partitions 1 --topic "$TOPIC"
 service cron start

exec "$@"