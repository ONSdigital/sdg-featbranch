FROM python:3.8.1-slim-buster
RUN pip install pika
RUN pip install requests
WORKDIR /src
CMD ["python", "-u", "respond.py"]