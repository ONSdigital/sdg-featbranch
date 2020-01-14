from flask import Flask
import os
import subprocess
import shutil

app = Flask(__name__)

@app.route('/<branch_name>')
def execute(branch_name):
    build_branch(branch_name)
    built_successfully = build_completed_successfully()

    if built_successfully:
        remove_existing_directory_from_server(branch_name)
        copy_built_site_to_server(branch_name)

    clean_up()
        
    return {
        "builtSuccessfully": built_successfully
    }

def build_branch(branch_name):
    subprocess.call(["sh", "/api/build.sh"], env={"branch": branch_name})

def build_completed_successfully():
    return os.path.exists("/tmp/data/_site")

def remove_existing_directory_from_server(branch_name):
    if os.path.exists("/server/data/" + branch_name):
        shutil.rmtree("/server/data/" + branch_name)

def copy_built_site_to_server(branch_name):
    shutil.copytree("/tmp/data/_site", "/server/data/" + branch_name)

def clean_up():
    shutil.rmtree("/tmp/data")