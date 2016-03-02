FROM localhost:5000/spark-base

CMD spark/sbin/start-master.sh -h spark-master && \
    sleep 2 && \
    tail -100f spark/logs/spark--org.apache.spark.deploy.master.Master-1-$(hostname).out
