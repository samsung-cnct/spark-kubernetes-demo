# Environment and deploy file
# For use with bin/server_deploy, bin/server_package etc.
DEPLOY_HOSTS="localhost"

APP_USER=root
APP_GROUP=root
# optional SSH Key to login to deploy server
#SSH_KEY=/path/to/keyfile.pem
INSTALL_DIR=/spark-jobserver
LOG_DIR=/spark-jobserver/logs
PIDFILE=spark-jobserver.pid
JOBSERVER_MEMORY=512m
SPARK_VERSION=1.5.1
SPARK_HOME=/spark
SPARK_CONF_DIR=$SPARK_HOME/conf
# Only needed for Mesos deploys
SPARK_EXECUTOR_URI=/Users/pieuler/spark-1.5.1/lib/spark-assembly-1.5.1-hadoop2.6.0.jar
# Only needed for YARN running outside of the cluster
# You will need to COPY these files from your cluster to the remote machine
# Normally these are kept on the cluster in /etc/hadoop/conf
# YARN_CONF_DIR=/pathToRemoteConf/conf
# HADOOP_CONF_DIR=/pathToRemoteConf/conf
#
# Also optional: extra JVM args for spark-submit
# export SPARK_SUBMIT_OPTS+="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5433"
SCALA_VERSION=2.10.4 # or 2.11.6
