# Spark Demo on Kubernetes

**Follow configurations to run Spark on Kubernetes**

// When I run it on VM via Vagrant
* export KUBERNETES_PROVIDER=vagrant
* export KUBERNETES_MEMORY=2048
* export NUM_MINIONS=4

// When I run it on AWS
* export KUBERNETES_PROVIDER=aws
* export MASTER_SIZE=t2.small
* export MINION_SIZE=t2.small
* export NUM_MINIONS=4


**You can watch the procedure for Starting Spark on Kubernetes**

https://github.com/kubernetes/kubernetes/pull/20298
