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

echo owner=$owner > ~/.featbranch/settings.conf
echo siteRepo=$siteRepo >> ~/.featbranch/settings.conf
echo dataRepo=$dataRepo >> ~/.featbranch/settings.conf
echo serverUrl=$serverUrl >> ~/.featbranch/settings.conf
echo githubToken=$githubToken >> ~/.featbranch/settings.conf

cp ./database/deployment.db ~/.featbranch/database

docker-compose down
docker-compose build repositoryclone

echo "Cloning repositories..."
owner=$owner siteRepo=$siteRepo dataRepo=$dataRepo docker-compose up repositoryclone
echo "Starting servers..."
docker-compose up -d server
docker-compose up -d githubapi
docker-compose up -d deploymentapi
echo "Installation complete."