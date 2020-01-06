from flask import Flask, request
import subprocess
import os
import time
import requests
app = Flask(__name__)

@app.route('/', methods=['POST'])
def loop():
    requests.post("http://deploy.iteration")
    time.sleep(120)