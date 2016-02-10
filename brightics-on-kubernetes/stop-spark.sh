status=0

printf "Stop spark...\n"
/Users/pieuler/kubernetes/cluster/kubectl.sh delete -f spark-master-controller.yaml 
/Users/pieuler/kubernetes/cluster/kubectl.sh delete -f spark-worker-controller.yaml 
/Users/pieuler/kubernetes/cluster/kubectl.sh delete -f spark-master-service.yaml 

/Users/pieuler/kubernetes/cluster/kubectl.sh get pods
while [ $(/Users/pieuler/kubernetes/cluster/kubectl.sh get pods | grep -E 'spark-master|spark-worker' | grep Terminating | wc -l) -gt 0 ]
do
  /Users/pieuler/kubernetes/cluster/kubectl.sh get pods
  sleep 1
done

/Users/pieuler/kubernetes/cluster/kubectl.sh get pods
printf "\nDone!!\n"
