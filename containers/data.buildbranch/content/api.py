from flask import Flask
import os
import subprocess
import shutil

app = Flask(__name__)

@app.route('/<branch_name>')
def build_data_branch(branch_name):
    subprocess.call(["sh", "/api/build.sh"], env={"branch": branch_name})
    build_successful = os.path.exists("/tmp/data/_site")

    if build_successful:
        if os.path.exists("/server/data/" + branch_name):
            shutil.rmtree("/server/data/" + branch_name)
            
        shutil.copytree("/tmp/data/_site", "/server/data/" + branch_name)

    shutil.rmtree("/tmp/data")
        
    return {
        "builtSuccessfully": build_successful
    }