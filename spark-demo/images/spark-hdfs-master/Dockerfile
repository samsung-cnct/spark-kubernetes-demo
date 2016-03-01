FROM nohkwangsun/spark-hdfs-base:latest

WORKDIR $SPARK_HOME

RUN wget https://s3-us-west-2.amazonaws.com/spark-kube-demo/chicago_crime.csv

EXPOSE 9000
EXPOSE 7078

CMD echo $(hostname -i) spark-master >> /etc/hosts && \
    export SPARK_MASTER_IP=spark-master && \
    export SPARK_MASTER_PORT=7077 && \
    /hadoop/bin/hdfs namenode -format && \
    /hadoop/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode && \
    $SPARK_HOME/sbin/start-master.sh -h spark-master && \
    tail -100f $SPARK_HOME/logs/spark--org.apache.spark.deploy.master.Master-1-$(hostname).out

