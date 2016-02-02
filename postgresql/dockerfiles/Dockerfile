FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y net-tools
RUN apt-get install -y postgresql postgresql-contrib

EXPOSE 5432

RUN service postgresql start


ADD brightics-postgresql.sql .
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

CMD echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf && \
    service postgresql start && \
    sudo -u postgres psql -c "create user brightics with password 'brightics' createdb" && \
    sudo -u postgres psql -c "create database brightics owner brightics" && \
    sudo -u postgres psql -U brightics -d brightics -f brightics-postgresql.sql && \
    tail -100f /var/log/postgresql/*

