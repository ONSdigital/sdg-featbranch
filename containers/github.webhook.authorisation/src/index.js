const express = require('express')
const crypto = require('crypto');

const app = express()
app.use(express.json())
const port = 80

app.post('/signatures-match', (req,res) => {
    var payloadFromGithub = req.body.payloadFromGithub
    var secret = req.body.secret
    var signatureFromGithub = req.body.signatureFromGithub

    var localSignature = getSignature(secret, payloadFromGithub)
    var match = signaturesMatch(localSignature, signatureFromGithub)
    res.send({
        "signaturesMatch": match
    })
})

function getSignature(secret, payload){
    const hmac = crypto.createHmac('sha1', secret)
    var signature = hmac.update(JSON.stringify(payload)).digest('hex')
    signature = "sha1=" + signature
    return signature
}

function signaturesMatch(signature, signatureToCompare){
    var preparedSignatures = {
        signature: Buffer.from(signature),
        signatureToCompare: Buffer.from(signatureToCompare)
    }

    var signaturesAreEqual = crypto.timingSafeEqual(preparedSignatures.signature, preparedSignatures.signatureToCompare)
    return signaturesAreEqual
}

app.listen(port, () => console.log(`App listening on port ${port}!`))
