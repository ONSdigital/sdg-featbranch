const express = require('express')
const bodyParser = require('body-parser')
const axios = require("axios")
const fs = require("fs")

const app = express()
app.use(bodyParser.urlencoded({ extended: true }))
const port = 80

app.post('/template/:template', (req, res) => {
    axios.get("http://app.settings/slackWebhook")
        .then((response) => {
            var slackWebhook = response.data
            var templateFilePath = "/templates/" + req.params.template + ".tpl"

            fs.readFile(templateFilePath, 'utf-8', (err,data) => {
                Object.keys(req.body).forEach((key, index) => {
                    data = data.split("{"+key+"}").join(req.body[key])
                })
                
                axios.post(slackWebhook, {"text":data})
                .catch((err) => {
                    console.log("Couldn't post message to Slack")
                })
            })
        })

    

    res.send(req.body)
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))