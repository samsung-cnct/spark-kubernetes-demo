FROM nohkwangsun/spark-base:latest

WORKDIR /

COPY brightics-v2.0_20151026-brightics-agent.tgz .
RUN tar zxf brightics-v2.0_20151026-brightics-agent.tgz
ADD settings.sh brightics-agent
WORKDIR brightics-agent

CMD ./server_start.sh && \
    sleep 2 && \
    tail -100f logs/*/spark-job-server.log

