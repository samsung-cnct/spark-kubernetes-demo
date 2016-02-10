FROM nohkwangsun/spark-base:latest


RUN apt-get install -y wget
RUN apt-get install -y curl      


RUN wget http://apache.arvixe.com/incubator/zeppelin/0.5.0-incubating/zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3.tgz


RUN tar xzf zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3.tgz
RUN mv      zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3/zeppelin-0.5.0-incubating zeppelin
RUN rmdir   zeppelin-0.5.0-incubating-bin-spark-1.4.0_hadoop-2.3 


ENV MASTER spark://spark-master:7077


EXPOSE 8080 8081 8082


CMD bin/zeppelin-daemon.sh start && tail -100f logs/*

