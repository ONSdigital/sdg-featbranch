# Prepare
rm -rf /tmp/site
cp -r /repositories/site /tmp/site
cd /tmp/site
git checkout $branch
sed -i "s/sdg-indicators/$branch/g" _config.yml