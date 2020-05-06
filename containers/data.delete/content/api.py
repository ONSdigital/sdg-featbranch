from flask import Flask
import shutil

app = Flask(__name__)

@app.route('/<branch_name>', methods=['POST'])
def delete_branch(branch_name):
    shutil.rmtree("/server/data/%s" % branch_name)
    shutil.rmtree("/server/datapreview_%s" % branch_name)
    return {
        "deletedSuccessfully": True
    }
