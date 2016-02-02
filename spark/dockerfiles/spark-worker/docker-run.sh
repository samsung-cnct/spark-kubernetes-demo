# the host port and the container port have to be same. not use -P, but -p hport:cport

docker run -d -p 7078:7078 --name=$1 --link sm01:spark-master pieuler/spark-worker
docker inspect --format '{{ .NetworkSettings.IPAddress }}' $1

