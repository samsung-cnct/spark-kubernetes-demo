FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y curl net-tools subversion

RUN apt-get update
RUN apt-get install -y apache2 apache2-utils libapache2-svn

ADD dav_svn.conf /etc/apache2/mods-available/dav_svn.conf

RUN /etc/init.d/apache2 restart
RUN htpasswd -cb /etc/subversion/passwd brightics brightics

EXPOSE 80 3690

#EXPOSE 3690
#CMD svnadmin create --fs-type fsfs /svn && \
#    echo “anon-access = read” >> /svn/conf/svnserve.conf && \
#    echo “auth-access = write” >> /svn/conf/svnserve.conf && \
#    echo “password-db = passwd” >> /svn/conf/svnserve.conf && \
#    echo “brightics = brightics” >> /svn/conf/passwd && \
#    mkdir -p /svn/log && \
#    svnserve -d --listen-port 3690 --log-file /svn/log/svn.log -r /svn && \
#    tail -100f /svn/log/*
