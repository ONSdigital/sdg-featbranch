FROM python:3.9.0a1-alpine3.10
RUN pip install flask
RUN apk add git
WORKDIR /api
CMD export FLASK_APP=api.py && flask run --host=0.0.0.0