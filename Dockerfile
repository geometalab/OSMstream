FROM java:openjdk-8-jre
MAINTAINER Samuel Kurath <skurath@hsr.ch>

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.0.1
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
ENV TOPIC "osm"
ENV KAFKA_PORT "2181"
ENV KAFKA_HOST "localhost"
ENV OSMSTREAM_HOME /opt/OSMstream/

ADD src/cron_diff.sh "$OSMSTEAM_HOME"
ADD src/producer.py "$OSMSTEAM_HOME"

EXPOSE $KAFKA_PORT

ENTRYPOINT ["./entrypoint.sh"]

RUN apt-get update \
    && apt-get install -y zookeeper vim python3-pip python3-dev python3 git cron\
    && pip3 install --upgrade pip \
    && wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz \
    && tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt \
    && (crontab -l 2>/dev/null; echo "*/1 * * * *  /opt/OSMstream/cron_diff.sh") | crontab - \
