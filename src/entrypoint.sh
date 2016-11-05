#!/bin/bash

chmod +x /opt/OSMstream/cron_diff.sh
chmod +x /opt/OSMstream/producer.py
chmod +x /opt/OSMstream/benchmark.py
$KAFKA_HOME/bin/zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
$KAFKA_HOME/bin/kafka-server-start.sh -daemon  $KAFKA_HOME/config/server.properties
$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper $KAFKA_HOST:$KAFKA_PORT --replication-factor 1 --partitions 1 --topic $TOPIC
/opt/apache-storm-1.0.2/bin/storm nimbus &
/opt/apache-storm-1.0.2/bin/storm supervisor &
service cron start
/opt/apache-storm-1.0.2/bin/storm ui

exec "$@"