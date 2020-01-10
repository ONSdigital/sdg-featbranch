var express = require('express')
var app = express()

app.use(express.json())
app.post('/', function (req, res) {
    var changeDetails = {
        repositoryName: req.body.repository.name,
        branchName: req.body.ref.split("/")[2],
        author: req.body.head_commit.author.name,
        message: req.body.head_commit.message
    }

    res.send("Done")
  })

  app.listen(80);
