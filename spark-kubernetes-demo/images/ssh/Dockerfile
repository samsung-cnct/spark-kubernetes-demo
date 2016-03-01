FROM java:latest

USER root

RUN apt-get update
RUN apt-get install -y wget vim openssh-server

#RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
#RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
#RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
#RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#ADD ssh_config /root/.ssh/config
#RUN chmod 600 /root/.ssh/config
#RUN chown root:root /root/.ssh/config

#RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
#RUN echo "UsePAM no" >> /etc/ssh/sshd_config
#RUN echo "Port 2122" >> /etc/ssh/sshd_config

#CMD service sshd start

RUN mkdir /var/run/sshd
RUN echo 'root:1234' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
CMD /usr/sbin/sshd
