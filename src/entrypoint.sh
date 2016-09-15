#!/bin/bash

chmod +x /opt/OSMstream/cron_diff.sh
chmod +x /opt/OSMstream/producer.py
$KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
$KAFKA_HOME/bin/kafka-server-start.sh -daemon  $KAFKA_HOME/config/server.properties
$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $KAFKA_HOST:$KAFKA_PORT --replication-factor 1 --partitions 1 --topic $TOPIC
service cron start
supervisord -n

exec "$@"