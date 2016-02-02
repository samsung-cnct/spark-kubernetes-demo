FROM nohkwangsun/spark-file



#INSTALL
RUN apt-get install -y curl      



#SPARK
ENV SPARK_DIR spark
ENV SPARK_HOME /$SPARK_DIR
RUN echo "${SPARK_MASTER_SERVICE_HOST} spark-master" >> /etc/hosts

WORKDIR $SPARK_PARENT
RUN tar xzf spark-1.4.0-bin-hadoop2.6.tgz
RUN ln -s spark-1.4.0-bin-hadoop2.6 $SPARK_DIR

EXPOSE 8080 4040 7077 7078

WORKDIR $SPARK_HOME/conf
RUN touch spark-env.sh
RUN echo SPARK_WORKER_PORT=7078 >> spark-env.sh


#SSH
#RUN apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
#RUN echo 'root:1234' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]

