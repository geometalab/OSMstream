#!/bin/bash

chmod +x /opt/OSMstream/cron_diff.sh
chmod +x /opt/OSMstream/producer.py
chmod +x /opt/OSMstream/benchmark.py
chmod +x /opt/OSMstream/test_diff.py
echo "fetch.message.max.bytes=100000000" >> /opt/kafka_2.11-0.10.0.1/config/consumer.properties
echo "replica.fetch.max.bytes=100000000" >> /opt/kafka_2.11-0.10.0.1/config/server.properties
echo "message.max.bytes=100000000" >> /opt/kafka_2.11-0.10.0.1/config/server.properties
echo "advertised.port=9092" >> /opt/kafka_2.11-0.10.0.1/config/server.properties
ip add show eth0 | grep -Eo 'inet \S+' | awk '{split($2,a,"/"); print "advertised.host.name="a[1]}' >> /opt/kafka_2.11-0.10.0.1/config/server.properties

service cron start
/usr/bin/supervisord

exec "$@"