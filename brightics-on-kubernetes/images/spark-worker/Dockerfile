FROM localhost:5000/spark-base

CMD spark/sbin/start-slave.sh spark://spark-master:7077 && \
    sleep 2 && \
    tail -100f spark/logs/spark--org.apache.spark.deploy.worker.Worker-1-$(hostname).out
