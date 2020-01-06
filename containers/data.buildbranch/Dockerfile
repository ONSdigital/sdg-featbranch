FROM python:3.8.1-slim-buster
RUN apt update
RUN apt install -y git
RUN pip install virtualenv
RUN pip install flask
WORKDIR /api
CMD export FLASK_RUN_PORT=80 && export FLASK_APP=api.py && flask run --host=0.0.0.0