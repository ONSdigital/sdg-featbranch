from flask import Flask, request
from SendService import SendService

app = Flask(__name__)

@app.route("/", methods=['POST'])
def hello():
    request_items = request.get_json()
    message = request_items["message"]
    send_service = SendService()
    send_service.send_message(message)
    return "Hello World!"

if __name__ == '__main__':
    app.run()