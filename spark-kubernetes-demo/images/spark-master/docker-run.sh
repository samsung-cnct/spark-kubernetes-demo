docker run -d -p 8080:8080 -p 7077:7077 -p 4040:4040 --name=sm01 --hostname=spark-master pieuler/spark-master
docker inspect --format '{{ .NetworkSettings.IPAddress }}' sm01

