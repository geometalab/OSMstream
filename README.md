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

### Kafka settings
- Host:     localhost
- Port:     2181
- Topic:    osm

##Links
- http://wiki.openstreetmap.org/wiki/Overpass_API/Augmented_Diffs
- http://wiki.openstreetmap.org/wiki/Planet.osm/diffs
- http://wiki.openstreetmap.org/wiki/OsmChange
