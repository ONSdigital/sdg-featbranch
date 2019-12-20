FROM debian:buster-slim
RUN apt update
RUN apt install -y git
RUN apt-get install -y ruby-full build-essential zlib1g-dev
RUN export GEM_HOME="$HOME/gems"
RUN export PATH="$HOME/gems/bin:$PATH"
RUN gem install jekyll bundler
CMD cd /repositories/sdg-indicators && chmod +x /root/build.sh && /root/build.sh