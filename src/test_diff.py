#!/usr/bin/python3
import argparse
import os

from kafka import KafkaProducer
from json import dumps
from xml.etree.ElementTree import fromstring
from xmljson import badgerfish as bf


def read_file(file_path):
    if not os.path.isfile(file_path): raise Exception('File does not exist. ' + file_path)
    with open(file_path, 'r') as content_file:
        content = content_file.read()
    return content


def run(args):
    kwargs = dict(bootstrap_servers=(args.ip + ':' + str(args.port)), max_request_size=int(1e+8))
    producer = KafkaProducer(**kwargs)
    path = "/opt/OSMstream/augmented_diffs/"
    for file in os.listdir(path):
        if file.endswith(".xml"):
            data = dumps(bf.data(fromstring(read_file(path + file))))
            data_bytes = str(data).encode('utf-8')
            future = producer.send(args.topic, data_bytes)
    producer.flush()
    print(future.get())


def mainfunc():
    parser = argparse.ArgumentParser(description='Produce input for stream benchmarks.', )

    parser.add_argument(
        '-i',
        '--ip',
        action='store',
        dest='ip',
        type=str,
        default='localhost',
        help='IP address of Kafka. (Default is localhost) '
    )

    parser.add_argument(
        '-p',
        '--port',
        action='store',
        dest='port',
        type=int,
        default='9092',
        help='Port of Kafka. (Default is 9092) '
    )

    parser.add_argument(
        '-t',
        '--topic',
        action='store',
        dest='topic',
        type=str,
        default='osm',
        help='Topic of Kafka. (Default is osm) '
    )
    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    mainfunc()
