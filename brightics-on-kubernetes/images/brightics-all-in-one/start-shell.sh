# postgresql
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
service postgresql start 
sudo -u postgres psql -c "create user brightics with password 'brightics' createdb"
sudo -u postgres psql -c "create database brightics owner brightics"
sudo -u postgres psql -U brightics -d brightics -f /brightics/brightics-postgresql.sql

# spark
cd /brightics/spark-1.4.0/sbin && \
./start-local-cluster.sh

# brightics-agent
cd /brightics/brightics-agent && \
./restart && \
sleep 3 && \
tail -1000f logs/9095/spark-job-server.log
