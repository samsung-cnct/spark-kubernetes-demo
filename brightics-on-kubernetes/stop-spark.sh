status=0

printf "Stop spark...\n"
kubectl.sh delete -f spark-master-controller.yaml 
kubectl.sh delete -f spark-worker-controller.yaml 
kubectl.sh delete -f spark-master-service.yaml 

kubectl.sh get pods
while [ $(kubectl.sh get pods | grep -E 'spark-master|spark-worker' | grep Terminating | wc -l) -gt 0 ]
do
  kubectl.sh get pods
  sleep 1
done

kubectl.sh get pods
printf "\nDone!!\n"
