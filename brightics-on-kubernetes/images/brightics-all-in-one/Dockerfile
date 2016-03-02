FROM ubuntu:14.04
ADD start-shell.sh /
RUN mkdir /brightics

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y net-tools
RUN apt-get install -y postgresql postgresql-contrib
RUN apt-get install -y openjdk-7-jdk

ADD brightics-postgresql.sql /brightics/.
ADD brightics-v2.0_20151021-forever-0.14.2.tgz /brightics/.
ADD brightics-v2.0_20151021-node-0.10.29.tgz /brightics/.
ADD brightics-v2.0_20151026-brightics-agent.tgz /brightics/.
ADD brightics-v2.0_20151026-brightics-cloudweb.tgz /brightics/.
ADD brightics-v2.0_20151026-brightics-server.tgz /brightics/.
ADD brightics-v2.0_20151026-spark-1.4.0.tgz /brightics/.
ADD brightics-v2.0_20151027-brightics-statistics.tgz /brightics/.
ADD brightics-v2.0_20151027-metadata_postgresql.tgz /brightics/.


#postgresl
EXPOSE 5432
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
RUN service postgresql start


#spark
EXPOSE 8080 8081 7077 7078


#brightics-aget
EXPOSE 9095 4040
ADD settings.sh /brightics/brightics-agent/.


CMD /start-shell.sh
