FROM nohkwangsun/spark-base:latest

WORKDIR $SPARK_HOME

EXPOSE 7078

CMD echo $(hostname -i) spark-master >> /etc/hosts && \
    export SPARK_MASTER_IP=spark-master && \
    export SPARK_MASTER_PORT=7077 && \
    sbin/start-master.sh -h spark-master && \
    tail -100f logs/spark--org.apache.spark.deploy.master.Master-1-$(hostname).out

