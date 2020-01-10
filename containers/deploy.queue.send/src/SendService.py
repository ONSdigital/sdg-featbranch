import pika

class SendService:
    def send_message(self, message):
        connection = pika.BlockingConnection(pika.ConnectionParameters('deployqueue'))
        channel = connection.channel()

        channel.queue_declare(queue='deploy')

        channel.basic_publish(exchange='',
            routing_key='deploy',
            body=message)