FROM nohkwangsun/spark-base:latest

WORKDIR $SPARK_HOME
CMD sbin/start-slave.sh spark://spark-master:7077 && tail -100f logs/spark--org.apache.spark.deploy.worker.Worker-1-$(hostname).out

