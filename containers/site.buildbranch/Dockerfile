FROM python:3.8.1-slim-buster
RUN apt update
RUN apt install -y git
RUN apt-get install -y ruby-full build-essential zlib1g-dev
RUN export GEM_HOME="$HOME/gems"
RUN export PATH="$HOME/gems/bin:$PATH"
RUN gem install jekyll bundler
RUN pip install flask
WORKDIR /api
CMD export FLASK_RUN_PORT=80 && export FLASK_APP=api.py && flask run --host=0.0.0.0