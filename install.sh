rm -rf ~/.featbranch
mkdir ~/.featbranch
mkdir ~/.featbranch/server
mkdir ~/.featbranch/server/data
mkdir ~/.featbranch/server/logs
mkdir ~/.featbranch/repositories
mkdir ~/.featbranch/database
mkdir ~/.featbranch/output

read -p "Repository owner: " owner
read -p "Site repository: " siteRepo
read -p "Data repository: " dataRepo
read -p "Server URL: " serverUrl
read -p "Github token: " githubToken
read -p "Slack webhook: " slackWebhook

echo owner=$owner > ~/.featbranch/settings.conf
echo siteRepo=$siteRepo >> ~/.featbranch/settings.conf
echo dataRepo=$dataRepo >> ~/.featbranch/settings.conf
echo serverUrl=$serverUrl >> ~/.featbranch/settings.conf
echo githubToken=$githubToken >> ~/.featbranch/settings.conf
echo slackWebhook=$slackWebhook >> ~/.featbranch/settings.conf

cp ./database/deployment.db ~/.featbranch/database

sudo docker-compose down
sudo docker-compose build

echo "Cloning repositories..."
sudo owner=$owner siteRepo=$siteRepo dataRepo=$dataRepo docker-compose up repositoryclone
echo "Starting servers..."
sudo docker-compose up -d server
sudo docker-compose up -d githubapi
sudo docker-compose up -d deploymentapi

chmod +x ./deploy.sh
chmod +x ./deployLoop.sh
echo "Installation complete."