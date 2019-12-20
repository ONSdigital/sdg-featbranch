# Prepare
cp -r /repositories/sdg-indicators /tmp/sdg-indicators
cd /tmp/sdg-indicators
git checkout develop
url=http://server/data/$dataBranch
urlEscaped=$(echo $url | sed "s/\//\\\\\//g")
sed -i "s/sdg-indicators/datapreview_$dataBranch/g" _config.yml
sed -i "s/https:\/\/ONSdigital.github.io\/sdg-data/$urlEscaped/g" _config.yml

# Build
bundle install
bundle exec jekyll build

# Change data URL
cd _site
serverUrlEscaped=$(echo $serverUrl | sed "s/\//\\\\\//g")
find . -type f -exec sed -i "s/http:\/\/server/$serverUrlEscaped/g" {} +
cd ..

#Signify success
success=0
[ -d "./_site" ] && success=1
rm -rf /output/success.out
echo $success > /output/success.out

# Move to server
rm -rf /server/datapreview_$dataBranch
mv _site /server/datapreview_$dataBranch

# Clean up
rm -rf /tmp/sdg-data