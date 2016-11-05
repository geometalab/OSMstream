#!/usr/bin/python3
import os
import epub
import argparse

from bs4 import BeautifulSoup
from kafka import KafkaProducer


def run(args):
    producer = KafkaProducer(bootstrap_servers='localhost:9092')
    dir_path = os.path.dirname(os.path.realpath(__file__))
    book = epub.open_epub(dir_path + '/how-to-make-mistakes-in-python.epub')
    text = ""
    for item_id, linear in book.opf.spine.itemrefs:
        item = book.get_item(item_id)
        soup = BeautifulSoup(book.read_item(item), 'html.parser')
        texts = soup.findAll(text=True)
        for t in texts:
            text += t + " "
    for i in range(1, args.rounds + 1):
        producer.send('benchmark', str.encode(i * text))
        producer.flush()


def mainfunc():
    parser = argparse.ArgumentParser(description='Produce input for stream benchmarks.', )
    parser.add_argument(
        '-r',
        '--rounds',
        action='store',
        dest='rounds',
        type=int,
        help='How many times should input be produced.',
        required=True
    )

    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    mainfunc()
