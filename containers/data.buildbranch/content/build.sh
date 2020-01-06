# Prepare
cp -r /repositories/data /tmp/data
cd /tmp/data
git checkout $branch

# Build
/usr/local/bin/virtualenv /databuilder
/databuilder/bin/pip install -r ./scripts/requirements.txt
/databuilder/bin/python ./scripts/check_data.py
/databuilder/bin/python ./scripts/build_data.py
rm -rf /databuilder