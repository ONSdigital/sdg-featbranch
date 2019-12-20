FROM debian:buster-slim
RUN apt update
RUN apt install -y git
RUN apt install -y git python3 python3-pip
RUN pip3 install requests
RUN pip3 install virtualenv
CMD cd /repositories/sdg-data && chmod +x /root/build.sh && /root/build.sh