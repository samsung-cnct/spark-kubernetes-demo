status=0

printf "Start spark-master...\n"
/Users/pieuler/kubernetes/cluster/kubectl.sh create -f spark-master-service.yaml
/Users/pieuler/kubernetes/cluster/kubectl.sh create -f spark-master-controller.yaml

/Users/pieuler/kubernetes/cluster/kubectl.sh get pods
while [ $(/Users/pieuler/kubernetes/cluster/kubectl.sh get pods | grep spark-master | grep Running | wc -l) -le 0 ]
do
  /Users/pieuler/kubernetes/cluster/kubectl.sh get pods
  sleep 1
done

sleep 3

printf "\nStart spark-worker...\n"
/Users/pieuler/kubernetes/cluster/kubectl.sh create -f spark-worker-controller.yaml
/Users/pieuler/kubernetes/cluster/kubectl.sh get pods
while [ $(/Users/pieuler/kubernetes/cluster/kubectl.sh get pods | grep spark-worker | grep Pending | wc -l) -gt 0 ]
do
  /Users/pieuler/kubernetes/cluster/kubectl.sh get pods
  sleep 1
done

/Users/pieuler/kubernetes/cluster/kubectl.sh get pods
printf "\nDone!!\n"
