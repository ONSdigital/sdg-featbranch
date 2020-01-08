from flask import Flask
import os
import subprocess
import shutil

app = Flask(__name__)

@app.route('/<branch_name>')
def build_site_branch(branch_name):
    subprocess.call(["sh", "/api/build.sh"], env={"branch": branch_name})
    os.chdir("/tmp/site")
    subprocess.call(["/usr/local/bin/bundle", "install"])
    subprocess.call(["/usr/local/bin/bundle", "exec", "jekyll", "build"])

    build_successful = os.path.exists("/tmp/site/_site")

    if build_successful:
        if os.path.exists("/server/" + branch_name):
            shutil.rmtree("/server/" + branch_name)

        shutil.copytree("/tmp/site/_site", "/server/" + branch_name)
        shutil.rmtree("/tmp/site")
        
    return {
        "builtSuccessfully": build_successful
    }
