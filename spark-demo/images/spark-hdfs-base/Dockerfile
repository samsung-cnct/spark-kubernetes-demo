FROM nohkwangsun/spark-file



#INSTALL
RUN apt-get update
RUN apt-get install -y curl vim



#HDFS
WORKDIR /
RUN wget http://apache.arvixe.com/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz
RUN tar xzf hadoop-2.6.4.tar.gz
RUN mkdir hadoop-2.6.4/logs
RUN chown -R root:root hadoop-2.6.4
RUN ln -s hadoop-2.6.4 hadoop

ENV HADOOP_PREFIX /hadoop
ENV HADOOP_COMMON_HOME /hadoop
ENV HADOOP_HDFS_HOME /hadoop
ENV HADOOP_MAPRED_HOME /hadoop
ENV HADOOP_YARN_HOME /hadoop
ENV HADOOP_CONF_DIR /hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ADD core-site.xml /hadoop/etc/hadoop/.
ADD hdfs-site.xml /hadoop/etc/hadoop/.



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
RUN touch spark-defaults.conf
RUN echo SPARK_WORKER_PORT=7078 >> spark-env.sh
RUN echo spark.master spark://spark-master:7077 >> spark-defaults.conf


#SSH
#RUN apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
#RUN echo 'root:1234' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#
# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile
#
#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]
