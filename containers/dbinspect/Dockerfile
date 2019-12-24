FROM alpine:3.10.3
RUN apk add sqlite
RUN echo ".headers on" >> /root/.sqliterc
RUN echo ".mode column" >> /root/.sqliterc
ENTRYPOINT [ "sqlite3", "/database/deployment.db", "SELECT * FROM Deployment ORDER BY deploymentDate DESC;" ]