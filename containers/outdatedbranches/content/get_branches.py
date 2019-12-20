import requests
import os

owner = os.environ["owner"]
site_repo = os.environ["siteRepo"]
data_repo = os.environ["dataRepo"]
token = os.environ["githubToken"]

site_branches = requests.get("http://githubapi:5000/allbranches/%s/%s?token=%s" % (owner, site_repo, token)).json()

output_file = open("/output/site.out", "w")
for each_branch in site_branches["branches"]:
    output_file.write(each_branch["name"] + "|" + each_branch["commit"]["sha"] + "\n")

output_file.close()

data_branches = requests.get("http://githubapi:5000/allbranches/%s/%s?token=%s" % (owner, data_repo, token)).json()

output_file = open("/output/data.out", "w")
for each_branch in data_branches["branches"]:
    output_file.write(each_branch["name"] + "|" + each_branch["commit"]["sha"] + "\n")

output_file.close()