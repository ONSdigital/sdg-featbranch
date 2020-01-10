var express = require('express')
var axios = require("axios")
var app = express()

app.use(express.json())
app.post('/', function (req, res) {
    var changeDetails = {
        repositoryName: req.body.repository.name,
        branchName: req.body.ref.split("/")[2],
        author: req.body.head_commit.author.name,
        message: req.body.head_commit.message
    }

    axios.post("http://github.webhook.response", changeDetails)
        .then((response) => {
            res.send(response.data)
        })
  })

  app.listen(80);
