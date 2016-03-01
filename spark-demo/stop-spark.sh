status=0

printf "Stop spark...\n"
kubectl.sh delete -f spark-hdfs-master-controller.yaml 
kubectl.sh delete -f spark-hdfs-worker-controller.yaml 
kubectl.sh delete -f spark-hdfs-master-service.yaml 
kubectl.sh delete rc spark-driver

kubectl.sh get pods
while [ $(kubectl.sh get pods | grep -E 'spark-master|spark-worker|spark-driver' | grep Terminating | wc -l) -gt 0 ]
do
  kubectl.sh get pods
  sleep 1
done

kubectl.sh get pods
printf "\nDone!!\n"
