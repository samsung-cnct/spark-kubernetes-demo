FROM java:latest

RUN apt-get update
RUN apt-get install -y wget

RUN wget http://apache.arvixe.com/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz 
RUN tar xzf hadoop-2.6.4.tar.gz
RUN ln -s hadoop-2.6.4 hadoop

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
RUN echo "export HADOOP_PREFIX=/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_COMMON_HOME=/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_HDFS_HOME=/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_MAPRED_HOME=/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_YARN_HOME=/hadoop" >> ~/.bashrc
RUN echo "export HADOOP_CONF_DIR=/hadoop/etc/hadoop" >> ~/.bashrc
RUN echo "export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop" >> ~/.bashrc

ADD core-site.xml /hadoop/etc/hadoop/.

RUN /hadoop/bin/hdfs namenode -format

