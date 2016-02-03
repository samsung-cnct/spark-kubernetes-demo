FROM gcr.io/google_containers/spark-base:1.5.1_v2

WORKDIR /
RUN wget https://dl.bintray.com/sbt/native-packages/sbt/0.13.9/sbt-0.13.9.tgz && \
    tar xzf sbt-0.13.9.tgz
ENV PATH $PATH:/sbt/bin 


COPY spark-jobserver-0.6.1.tgz .
RUN tar xzf spark-jobserver-0.6.1.tgz
ADD local.conf /spark-jobserver/.
ADD settings.sh /spark-jobserver/.
EXPOSE 8090


WORKDIR spark-jobserver
CMD ./server_start.sh && \
    sleep 2 && \
    tail -1000f logs/spark-job-server.log
