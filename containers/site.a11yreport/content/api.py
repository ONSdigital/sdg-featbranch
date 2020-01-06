from flask import Flask, escape, request
import subprocess

app = Flask(__name__)

@app.route('/<branch_name>')
def generate_report(branch_name):
    url = "http://server/%s" % branch_name
    subprocess.call(["a11ym", url, "-o", "/server/%s/accessibility" % branch_name, "--ignore-robots-txt"])
    return {
        "url": url
    }