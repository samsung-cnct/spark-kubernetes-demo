# Spark Demo on Kubernetes

**Before you start, below configuration setting is needed**

// If you want to run it on VM via Vagrant
* export KUBERNETES_PROVIDER=vagrant
* export KUBERNETES_MEMORY=2048
* export NUM_MINIONS=4

// If you want to run it on AWS
* export KUBERNETES_PROVIDER=aws
* export MASTER_SIZE=t2.small
* export MINION_SIZE=t2.small
* export NUM_MINIONS=4


**You can watch the procedure for Starting Spark on Kubernetes**

Demo video is based on spark-kubernetes-release-1.1

https://asciinema.org/a/35027


**Project Summary**
* **spark-kubernetes-release-master** is based on https://github.com/kubernetes/kubernetes/tree/master/examples/spark

* **spark-kubernetes-release-1.1** is based on * https://github.com/kubernetes/kubernetes/tree/release-1.1/examples/spark

* **brightics-on-kubernetes** is a project which tries to run Brightics on Kubernetes. Brightics is a big data analytics platform which is based on spark-1.4.0.
