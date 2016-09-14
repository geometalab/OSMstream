import sys
import argparse

from kafka import KafkaProducer
from json import dumps
from xml.etree.ElementTree import fromstring
from xmljson import badgerfish as bf


def produce(args):
    producer = KafkaProducer(bootstrap_servers=str(args.host) + ':' + str(args.port))
    data = dumps(bf.data(fromstring(sys.stdin.read())))
    producer.send(args.topic, str.encode(str(data)))
    producer.flush()


def main_func():
    parser = argparse.ArgumentParser(description='OSM minutely diffs to kafka.', )
    parser.add_argument(
        '--topic',
        action='store',
        dest='topic',
        default='osm',
        help='topic defined in kafka')
    parser.add_argument(
        '--port',
        action='store',
        dest='port',
        default='9092',
        help='kafka port')
    parser.add_argument(
        '--host',
        action='store',
        dest='host',
        default='localhost',
        help='kafka host')

    args = parser.parse_args()
    produce(args)


if __name__ == "__main__":
    main_func()
