from flask import Flask, request
import subprocess
import json
import os

app = Flask(__name__)

@app.route('/<owner>/<repository_name>', methods=['POST'])
def get_all_branches(owner, repository_name):
    os.chdir("/root")
    result = subprocess.run(["git", "clone", "https://github.com/%s/%s.git" % (owner, repository_name)])
    return {
        "returnCode": result.returncode
    }