status=0

printf "Start spark-master...\n"
kubectl.sh create -f spark-master-service.yaml
kubectl.sh create -f spark-master-controller.yaml

kubectl.sh get pods
while [ $(kubectl.sh get pods | grep spark-master | grep Running | wc -l) -le 0 ]
do
  kubectl.sh get pods
  sleep 1
done

sleep 3

printf "\nStart spark-worker...\n"
kubectl.sh create -f spark-worker-controller.yaml
kubectl.sh get pods
while [ $(kubectl.sh get pods | grep spark-worker | grep Pending | wc -l) -gt 0 ]
do
  kubectl.sh get pods
  sleep 1
done

kubectl.sh get pods
printf "\nDone!!\n"
