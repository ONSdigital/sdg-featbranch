from flask import Flask, request
import json
import sqlite3

app = Flask(__name__)

@app.route('/add-entry', methods=['POST'])
def add_entry():
    connection = sqlite3.connect("/database/deployment.db")
    cursor = connection.cursor()
    branch_name = request.form.get("branch")
    repository = request.form.get("repository")
    latest_commit = request.form.get("latestCommit")
    cursor.execute("INSERT INTO Deployment (branchName, repository, latestCommit) VALUES (?, ?, ?);", (branch_name, repository, latest_commit))
    connection.commit()
    return "1"

@app.route('/branch-is-up-to-date/<repository>/<branch_name>/<commit>')
def branch_is_up_to_date(repository, branch_name, commit):
    connection = sqlite3.connect("/database/deployment.db")
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) AS numberOfEntries FROM Deployment WHERE branchName=? AND repository=? AND latestCommit=?", (branch_name, repository, commit))
    entry_count = cursor.fetchone()[0]
    is_up_to_date = False if entry_count == 0 else True
    return {
        "upToDate": is_up_to_date
    }