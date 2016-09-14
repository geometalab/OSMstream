#!/usr/bin/python3
import io
import sys

from kafka import KafkaProducer
from json import dumps
from xml.etree.ElementTree import fromstring
from xmljson import badgerfish as bf

input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
producer = KafkaProducer(bootstrap_servers='localhost:9092')
data = dumps(bf.data(fromstring(input_stream.read()	)))
producer.send('osm', str.encode(str(data)))
producer.flush()

