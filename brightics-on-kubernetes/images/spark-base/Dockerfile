FROM java:latest

RUN apt-get update
RUN apt-get install -y wget curl net-tools

COPY brightics-v2.0_20151026-spark-1.4.0.tgz .
RUN tar xzf brightics-v2.0_20151026-spark-1.4.0.tgz
RUN mv spark-1.4.0 spark
RUN echo "${SPARK_MASTER_SERVICE_HOST} spark-master" >> /etc/hosts

ENV SPARK_MASTER_IP spark-master
ENV SPARK_MASTER_PORT 7077
ENV SPARK_WORKER_PORT 7078
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_WEBUI_PORT 8081

EXPOSE 8080 8081 4040 7077 7078
