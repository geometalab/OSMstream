FROM java:openjdk-8-jre
MAINTAINER Samuel Kurath <skurath@hsr.ch>

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.0.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV KAFKA_HOME /opt/kafka_2.11-0.10.0.1
ENV TOPIC "osm"

EXPOSE 2181 9092


COPY src/cron_diff.sh /opt/OSMstream/
COPY src/producer.py /opt/OSMstream/
COPY src/entrypoint.sh /opt/OSMstream/
COPY src/benchmark.py /opt/OSMstream/
COPY src/test_diff.py /opt/OSMstream/
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY augmented_diffs /opt/OSMstream/augmented_diffs/

ENTRYPOINT ["./opt/OSMstream/entrypoint.sh"]

RUN apt-get update \
    && apt-get install -y curl zookeeper vim python3-pip python3-dev python3 cron supervisor\
    && pip3 install --upgrade pip \
    && pip3 install xmljson \
    && pip3 install kafka-python \
    && wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz \
    && tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt \
    && (crontab -l 2>/dev/null; echo "*/1 * * * *  /opt/OSMstream/cron_diff.sh") | crontab - \
    && chmod +x /opt/OSMstream/entrypoint.sh \
