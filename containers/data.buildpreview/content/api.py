from flask import Flask, request
import os
import subprocess
import shutil
# from distutils.dir_util import copy_tree

app = Flask(__name__)

@app.route('/<data_branch_name>')
def build_preview(data_branch_name):
    serverUrl = request.args.get("serverUrl", "")
    
    shutil.copytree("/repositories/site", "/tmp/site")
    
    os.chdir("/tmp/site")
    subprocess.call(["git", "checkout", "develop"])

    config_file = open("_config.yml", "r").read()
    config_file = config_file.replace("sdg-indicators", "datapreview_%s" % data_branch_name)
    config_file = config_file.replace("https://ONSdigital.github.io/sdg-data", "http://server/data/%s" % data_branch_name)
    open("_config.yml", "w").write(config_file)

    subprocess.call(["/usr/local/bin/bundle", "install"])
    subprocess.call(["/usr/local/bin/bundle", "exec", "jekyll", "build"])

    build_successful = os.path.exists("/tmp/site/_site")

    if build_successful:
        for each_directory, subdirectories, files in os.walk("/tmp/site/_site"):
            for each_file in files:
                full_path = "%s/%s" % (each_directory, each_file)
                if full_path.endswith(".html"):
                    content = open(full_path, "r").read()
                    content = content.replace("http://server", serverUrl)
                    open(full_path, "w").write(content)

        shutil.move("/tmp/site/_site", "/server/datapreview_%s" % data_branch_name)

    shutil.rmtree("/tmp/site")
    return {
        "builtSuccessfully": build_successful
    }
