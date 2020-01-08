from flask import Flask, request
import subprocess
import os
import time
import requests
app = Flask(__name__)

@app.route('/', methods=['POST'])
def loop():
    while True:
        print("Starting deployment loop...")
        requests.post("http://deploy.iteration")
        print("Deploy loop completed. Starting again in 2 minutes...")
        time.sleep(120)
    return "Completed"