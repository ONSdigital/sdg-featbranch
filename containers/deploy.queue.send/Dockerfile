FROM python:3.8.1-slim-buster
RUN pip install --upgrade pip
RUN pip install pika
RUN pip install flask
WORKDIR /src
CMD export FLASK_RUN_PORT=80 && export FLASK_APP=api.py && flask run --host=0.0.0.0