FROM lloydg/the-a11y-machine
RUN apt update
RUN apt install -y python3 python3-pip
RUN pip3 install flask
WORKDIR /api
CMD export LC_ALL=C.UTF-8 && export LANG=C.UTF-8 && export FLASK_RUN_PORT=80 && export FLASK_APP=api.py && flask run --host=0.0.0.0