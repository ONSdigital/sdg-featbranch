var express = require('express')
var axios = require("axios")
var app = express()

app.use(express.json())
app.post('/', function (req, res) {
    authoriseRequest(req.body, req.headers['x-hub-signature'])
    .then(response => {
        if(response.signaturesMatch == true){
            sendToResponseService(getChangeDetailsFromRequest(req))
            .then(() => {
                res.send("Received")
            })
        }
    })

  })

async function authoriseRequest(payload, signatureToMatch){
    let secret
    await getSecretFromSettings().then((response) => {
        secret = response
    })
    
    return axios.post("http://github.webhook.authorisation/signatures-match", {
        "payloadFromGithub": payload,
        "secret": secret,
        "signatureFromGithub": signatureToMatch
    }).then((response) => {
        return response.data
    })
}

async function getSecretFromSettings(){
    return await axios.get("http://app.settings/githubSecret")
    .then((response) => {
        return response.data
    })
}

function getChangeDetailsFromRequest(request){
    var changeDetails = {
        repositoryName: request.body.repository.name,
        branchName: request.body.ref.split("/")[2],
        author: request.body.head_commit.author.name,
        message: request.body.head_commit.message
    }
    return changeDetails
}

function sendToResponseService(changeDetails){
    return axios.post("http://github.webhook.response", changeDetails)
    .then((response) => {
        return response.data
    })
}

  app.listen(80);
