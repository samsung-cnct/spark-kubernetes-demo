FROM nohkwangsun/spark-file



#INSTALL
RUN apt-get update
RUN apt-get install -y curl vim



#SPARK
ENV SPARK_DIR spark
ENV SPARK_HOME /$SPARK_DIR
RUN echo "${SPARK_MASTER_SERVICE_HOST} spark-master" >> /etc/hosts

WORKDIR $SPARK_PARENT
RUN tar xzf spark-1.4.0-bin-hadoop2.4.tgz
RUN ln -s spark-1.4.0-bin-hadoop2.4 $SPARK_DIR

EXPOSE 8080 4040 7077 7078

WORKDIR $SPARK_HOME/conf
RUN touch spark-env.sh
RUN echo SPARK_WORKER_PORT=7078 >> spark-env.sh
