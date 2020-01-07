appPath=$PWD

rm -rf ~/.featbranch
mkdir ~/.featbranch
mkdir ~/.featbranch/server
mkdir ~/.featbranch/server/data
mkdir ~/.featbranch/repositories
mkdir ~/.featbranch/database

read -p "Repository owner: " owner
read -p "Site repository: " siteRepo
read -p "Data repository: " dataRepo
read -p "Server URL: " serverUrl
read -p "Github token: " githubToken
read -p "Slack webhook: " slackWebhook

cd ~/.featbranch/repositories
git clone https://github.com/$owner/$siteRepo.git site
git clone https://github.com/$owner/$dataRepo.git data

echo owner=$owner > ~/.featbranch/settings.conf
echo siteRepo=$siteRepo >> ~/.featbranch/settings.conf
echo dataRepo=$dataRepo >> ~/.featbranch/settings.conf
echo serverUrl=$serverUrl >> ~/.featbranch/settings.conf
echo githubToken=$githubToken >> ~/.featbranch/settings.conf
echo slackWebhook=$slackWebhook >> ~/.featbranch/settings.conf

cd $appPath

cp ./database/deployment.db ~/.featbranch/database

chmod +x loop.sh
sudo docker-compose down
sudo docker-compose build
sudo docker-compose up -d

echo "Installation complete."