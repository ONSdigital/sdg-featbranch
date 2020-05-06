import pika
import os
import requests
import json

HOST = "deployqueue"
QUEUE_NAME = "deploy"

def wait_for_messages():
    channel = get_channel()

    channel.basic_consume(queue=QUEUE_NAME, on_message_callback=receive_message, auto_ack=True)
    channel.start_consuming()

def get_channel():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=HOST))
    channel = connection.channel()
    channel.queue_declare(queue=QUEUE_NAME)
    return channel

def receive_message(ch, method, properties, body):
        message = body.decode("utf-8")
        respond_to_message(message)

def respond_to_message(message):
    split_message = message.split("||")
    repository_name = split_message[0]
    branch_name = split_message[1]
    author = split_message[2]
    message = split_message[3]
    deleted = split_message[4]

    headers = {
        'Content-Type': 'application/json'
    }

    data = {
        "repositoryName": repository_name,
        "branchName": branch_name,
        "author": author,
        "message": message,
        "deleted": deleted
    }

    response = requests.post("http://deploy.execute", headers=headers, data=json.dumps(data))

wait_for_messages()