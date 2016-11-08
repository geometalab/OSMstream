#!/usr/bin/python3
import argparse
from random import choice

from kafka import KafkaProducer

# https://de.wikipedia.org/wiki/MQTT
topic_names = ["fridge", "icebox", "refrigerator", "door", "table", "window", "mobile", "computer", "weather"]
quality_of_service_level = [str(i) for i in range(10)]
retain_flag = ["False", "True"]
payload = [str(i) for i in range(100)]
dub_flag = retain_flag


def generate_message(id):
    return str(id) + " " + choice(topic_names) + " " + choice(quality_of_service_level) + " " + choice(
        retain_flag) + " " + choice(payload) + " " + choice(dub_flag)


def run(args):
    producer = KafkaProducer(bootstrap_servers=args.ip + ':' + str(args.port))

    for i in range(args.number_of_messages):
        message = generate_message(i)
        producer.send('benchmark', str.encode(message))
    producer.flush()


def mainfunc():
    parser = argparse.ArgumentParser(description='Produce input for stream benchmarks.', )
    parser.add_argument(
        '-n',
        '--number_of_messages',
        action='store',
        dest='number_of_messages',
        type=int,
        help='Number of messages to produce.',
        required=True
    )

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

    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    mainfunc()
