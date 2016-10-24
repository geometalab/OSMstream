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
The idea is now to test your streaming database with the OSM diff data provided by kafka.

###Kafka settings
- Host:     localhost
- Port:     2181
- Topic:    osm, benchmark

###Benchmak
Benchmarking is a very difficult topic and strongly depends on the various parameters like the underlying hardware.
So we decide to make this as hardware independent as possible. The idea is to produce kafka messages with "a lot of text" and for the consumer the goal is to count the words of the text and track the used processing time.
The we repeat this process with the double text length and so on. After a few iteration you can relate the processing time and the text length.

Start the message producer: 
```shell
docker exec -it osmstream bash
python3 /opt/OSMstream/benchmark.py -r 10
```
(the parameter -r is the number of produced messages)

##Links
- http://wiki.openstreetmap.org/wiki/Overpass_API/Augmented_Diffs
- http://wiki.openstreetmap.org/wiki/Planet.osm/diffs
- http://wiki.openstreetmap.org/wiki/OsmChange
