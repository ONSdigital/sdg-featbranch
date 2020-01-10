appPath=$PWD

rm -rf ~/.featbranch
mkdir ~/.featbranch
mkdir ~/.featbranch/server
mkdir ~/.featbranch/server/data
mkdir ~/.featbranch/repositories
mkdir ~/.featbranch/database
mkdir ~/.featbranch/settings

read -p "Repository owner: " owner
read -p "Site repository: " siteRepo
read -p "Data repository: " dataRepo
read -p "Server URL: " serverUrl
read -p "Slack webhook: " slackWebhook

echo $owner > ~/.featbranch/settings/owner
echo $siteRepo >> ~/.featbranch/settings/siteRepo
echo $dataRepo >> ~/.featbranch/settings/dataRepo
echo $serverUrl >> ~/.featbranch/settings/serverUrl
echo $slackWebhook >> ~/.featbranch/settings/slackWebhook

cd ~/.featbranch/repositories
git clone https://github.com/$owner/$siteRepo.git site
git clone https://github.com/$owner/$dataRepo.git data

cd $appPath

cp ./database/deployment.db ~/.featbranch/database

chmod +x loop.sh
sudo docker-compose down
sudo docker-compose build
sudo docker-compose up -d

echo "Installation complete."