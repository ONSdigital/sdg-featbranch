FROM python:3.7.6-alpine3.11
RUN pip install flask
WORKDIR /api
CMD export FLASK_RUN_PORT=80 && export FLASK_APP=api.py && flask run --host=0.0.0.0