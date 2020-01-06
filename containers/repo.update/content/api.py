from flask import Flask, request
import subprocess
import os

app = Flask(__name__)

@app.route('/<repository_type>', methods=['POST'])
def get_all_branches(repository_type):
    os.chdir("/root/%s" % repository_type)
    result = subprocess.run(["git", "pull"])
    return {
        "returnCode": result.returncode
    }