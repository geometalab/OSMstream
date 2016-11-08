# OSMstream
The repository provides a docker container which collects the Augmented diffs (change sets) from OpenStreetMap.
The diffs are provided in XML format and can be accessed over the overpass API. For further use we convert them into JSON format and publish them with apache kafka.
After that the data is ready for a streaming database of your choice.

![Overview](img/streaming_db.png)

##Installation
Pull the repository, build the docker container and run the container. 

###Docker
```shell
cd OSMstream
docker build -t osmstream .
docker run -d --name osmstream -p 2181:2181 osmstream
```

If you'd like to verify if there is something going on, use the following command.
```shell
docker exec -it osmstream bash
/opt/kafka_2.11-0.10.0.1/bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic osm --from-beginning
```


##Usage
To test your streaming database with the OSM diff data provided by kafka.

###Kafka settings
- Host:     localhost
- Port:     2181
- Topic:    osm, benchmark

##Benchmak
Benchmarking is a very difficult topic and strongly depends on various parameters like the underlying hardware.
Thus we decide to make this as hardware independent as possible. 

The idea is to produce a lot of small kafka message, like IoT does, and to count all the words of them. 
Then repeat this process and relate the number of processed messages with the time spent to count the words of them.

###Setup

The "benchmark.py" script produces the messages as a kafka producer and can be used like in the next box. (The parameter IP and Port are optional)

```shell
usage: benchmark.py [-h] -n NUMBER_OF_MESSAGES [-i IP] [-p PORT]

Produce input for stream benchmarks.

optional arguments:
  -h, --help            show this help message and exit
  -n NUMBER_OF_MESSAGES, --number_of_messages NUMBER_OF_MESSAGES
                        Number of messages to produce.
  -i IP, --ip IP        IP address of Kafka. (Default is localhost)
  -p PORT, --port PORT  Port of Kafka. (Default is 9092)
```


Example usage: 
```shell
docker exec -it osmstream bash
python3 /opt/OSMstream/benchmark.py -n 1000
```


###Small Messages
The small messages are inspired by MQTT.
![MQTT](img/publish_packet.png)&nbsp;

This messages are only generated samples for testing and look like the following.

0 weather 5 False 83 True
1 computer 2 True 82 False
2 weather 9 False 6 False
3 icebox 3 True 85 True
4 door 6 False 48 True
5 door 5 True 7 False



##Links
- http://wiki.openstreetmap.org/wiki/Overpass_API/Augmented_Diffs
- http://wiki.openstreetmap.org/wiki/Planet.osm/diffs
- http://wiki.openstreetmap.org/wiki/OsmChange
- https://en.wikipedia.org/wiki/MQTT
