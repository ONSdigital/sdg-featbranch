# Prepare
cp -r /repositories/sdg-data /tmp/sdg-data
cd /tmp/sdg-data
git checkout $branch

# Build
virtualenv /databuilder
/databuilder/bin/pip3 install -r ./scripts/requirements.txt
/databuilder/bin/python3 ./scripts/check_data.py
/databuilder/bin/python3 ./scripts/build_data.py
rm -rf /databuilder

#Signify success
success=0
[ -d "./_site" ] && success=1
rm -rf /output/databuildSuccess.out
echo $success > /output/databuildSuccess.out

# Move to server
rm -rf /server/data/$branch
mv _site /server/data/$branch

# Clean up
rm -rf /tmp/sdg-data