# Prepare
cp -r /repositories/sdg-indicators /tmp/sdg-indicators
cd /tmp/sdg-indicators
git checkout $branch
sed -i "s/sdg-indicators/$branch/g" _config.yml

# Build
bundle install
bundle exec jekyll build

#Signify success
success=0
[ -d "./_site" ] && success=1
rm -rf /output/sitebuildSuccess.out
echo $success > /output/sitebuildSuccess.out

# Move to server
rm -rf /server/$branch
mv _site /server/$branch

# Clean up
rm -rf /tmp/sdg-indicators