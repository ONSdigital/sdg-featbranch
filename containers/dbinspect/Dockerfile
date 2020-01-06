FROM alpine:3.10.3
RUN apk add sqlite
RUN echo ".headers on" >> /root/.sqliterc
RUN echo ".mode column" >> /root/.sqliterc
CMD tail -f