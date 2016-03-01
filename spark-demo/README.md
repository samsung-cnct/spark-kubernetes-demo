# Spark Demo on Kubernetes

## Overview

This project is for the demo of the apache spark on kuberntes

If you follow this example, you can learn about ...

* how to run Apache Spark on kubernetes,
* how to use HDFS on kubernetes and
* some Spark scripts.

( In this example, we will use HDFS. Of course you can S3 or RDB also )

## Mission
The mission of this example are ...

* Top 5 (per capita) violent crimes in Chicago
* Top 5 (per capita) non-violent crimes in Chicago
* Top 5 (per capita) locations with violent crimes in Chicago
* Top 5 (per capita) locations with non-violent crimes in Chicago

We will resolve a real world Spark/Kubernetes example using Chicago crime
so that we can concentrate on the example easily.

[data] https://s3-us-west-2.amazonaws.com/spark-kube-demo/chicago_crime.csv (1.1 GB)
[ORIGIN](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2)

[data] https://s3-us-west-2.amazonaws.com/spark-kube-demo/crime_description.csv (16 KB)

[data] https://s3-us-west-2.amazonaws.com/spark-kube-demo/violent_crime.csv (2.5 KB)


## Step Zero: Preparation

Before you start ...

Kubernetes was installed on your machine.

Refer to http://kubernetes.io/v1.1/docs/getting-started-guides/README.html

In this example, I will use Local VM with Vagrant

* Set variables

```console
export KUBERNETES_HOME=???
export PATH=$PATH:${KUBERNETES_HOME}/cluster
alias kubectl='${KUBERNETES_HOME}/cluster/kubectl.sh'
export KUBERNETES_PROVIDER=vagrant
export KUBERNETES_MEMORY=2048
export NUM_MINIONS=4
```

* Start kubernetes

```console
$ kube-up.sh
```

## Step One: Running Spark-Cluster

 > For the impatient, start-spark.sh is prepared
 
* Start Spark-Master
```console
$ kubectl create -f spark-hdfs-master-service.yaml
service "spark-master" created
$ kubectl create -f spark-hdfs-master-controller.yaml
replicationcontroller "spark-master" created
```

* Check the Spark-Master's status

```console
$ kubectl get pods -w
NAME                 READY     STATUS    RESTARTS   AGE                                                                 
spark-master-o6pth   0/1       Pending   0          6s                                                                  
NAME                 READY     STATUS    RESTARTS   AGE                                                                 
spark-master-o6pth   0/1       Running   0          10s                                                                 
spark-master-o6pth   1/1       Running   0          10s
^C
```

* Monitor the Cluster using Spark WebUI & Hadoop WebUI

> You can see the Spark-WebUI(8080) and Hadoop-WebUI(50070) on your web-browser

```console
$ kubectl get -o template pod spark-master-o6pth --template={{.status.hostIP}}
10.245.1.3
$ curl -s 10.245.1.3:8080
...HTML...
$ curl -s 10.245.1.3:8080 | grep -i used
                0 Used</li>                                                                                             
                0.0 B Used</li>
```

* Start Spark-Worker

```console
$ kubectl create -f spark-hdfs-worker-controller.yaml                    
replicationcontroller "spark-worker" created
$ kubectl get pods -w
NAME                 READY     STATUS    RESTARTS   AGE                                                                 
spark-master-o6pth   1/1       Running   0          1m                                                                  
spark-worker-91tqy   0/1       Pending   0          4s                                                                  
spark-worker-r3xca   0/1       Pending   0          4s                                                                  
NAME                 READY     STATUS    RESTARTS   AGE                                                                 
spark-worker-91tqy   0/1       Running   0          5s                                                                  
spark-worker-r3xca   0/1       Running   0          6s                                                                   
spark-worker-r3xca   1/1       Running   0          6s                                                                   
spark-worker-91tqy   1/1       Running   0          6s                                                                    ^C
$ curl -s 10.245.1.3:8080 | grep -i used                                 
                0 Used</li>                                                                                             
                0.0 B Used</li>                                                                                         
      <td>4 (0 Used)</td>                                                                                               
        (0.0 B Used)                                                                                                    
      <td>4 (0 Used)</td>                                                                                               
        (0.0 B Used)                                                                                                    
```

## Step Two: Load Datasets into HDFS

* Download files

```console
$ kubectl exec spark-mster-o6pth -- \                                  
   wget https://s3-us-west-2.amazonaws.com/spark-kube-demo/chicago_crime.csv
$ kubectl exec spark-mster-o6pth -- \                                  
   wget https://s3-us-west-2.amazonaws.com/spark-kube-demo/crime_description.csv  
$ kubectl exec spark-mster-o6pth -- \                                  
   wget https://s3-us-west-2.amazonaws.com/spark-kube-demo/violent_crime.csv
```

* Put files into HDFS
```console
$ kubectl exec spark-master-o6pth -- \                                   
   /hadoop/bin/hdfs dfs -put chicago_crime.csv / 
$ kubectl exec spark-master-o6pth -- \                                   
   /hadoop/bin/hdfs dfs -put crime_description.csv / 
$ kubectl exec spark-master-o6pth -- \                                   
   /hadoop/bin/hdfs dfs -put violent_crime.csv / 
```

* Check the files in HDFS
```console
$ kubectl exec spark-master-o6pth -- /hadoop/bin/hdfs dfs -ls /
Found 3 items                                                                                                           
-rw-r--r--   2 root supergroup 1219029039 2016-03-01 01:53 /chicago_crime.csv                                           
-rw-r--r--   2 root supergroup      16451 2016-03-01 01:51 /crime_description.csv                                       
-rw-r--r--   2 root supergroup       2623 2016-03-01 01:51 /violent_crime.csv 
```

## Step Three: Start Spark-Shell

* Start spark-driver pod
```console
$ kubectl run -i -tty spark-driver --image=nohkwangsun/spark-hdfs-base bash
Flag shorthand -t has been deprecated, please use --template instead                                                    
Waiting for pod to be scheduled                                                                                         
Waiting for pod default/spark-driver-x8lip to be running, status is Pending, pod ready: false                           
Waiting for pod default/spark-driver-x8lip to be running, status is Running, pod ready: false
```

* Start Spark-Shell
```console
$ /spark/bin/spark-shell --master spark://spark-master:7077 \                                                             
  --num-executors 2 \                                                                                                   
  --total-executor-cores 2 --executor-memory 512m
...
...
scala>
```

## Step Four: Read datasets from HDFS

* Import packages to make the schema info of the dataset
```console
scala> // Check that the context is loaded successfully.
scala> sc.master
res0: String = spark://spark-master:7077
scala> sc.defaultParallelism
res1: Int = 2
```

* Read Violent Crime File
```console
val textOfViolentType = sc.textFile("/violent_crime.csv")
val arrayVT = textOfViolentType.map(i => i.split(",",2)(0)).collect
```

* Read Crime Description File

> You can't read data from S3 using Hadoop 2.6 prebuilt pacakge.
> ( The community files of Kubernetes-repo uses Hadoop 2.6 prebuilt package )
> So, if you want to run this example on kubernetes,
> you have to make your own images or use these images that I made already.
> https://issues.apache.org/jira/browse/SPARK-7442

```console
val crimeDesc = sc.textFile("/crime_description.csv").collect
val crimeDescriptionMap  = crimeDesc.map(_.split(",")).
  map(i => (i(0),i(1))).toMap
val descOf = (iucr: String) =>
  scala.util.Try(crimeDescriptionMap(iucr)).getOrElse("N/A")
```

* Read Chicago Crime File
```console
val text = sc.textFile("/chicago_crime.csv")
text.take(5).foreach(i => println(i + "\n"))
val header = text.first
val body = text.filter(i => i!=header)

val blockIndex = header.split(",").zipWithIndex.filter(_._1 == "Block")
val iucrIndex = header.split(",").zipWithIndex.filter(_._1 == "IUCR")
val data = body.map(_.split(",")).
  map(i => (i(3),i(4),violentTypeVar.value.contains(i(4))))
```

* Cache
```console
val violentData = data.filter(_._3)
violentData.cache
val nonViolentData = data.filter(! _._3)
nonViolentData.cache
```

## Step Five: Run Spark-Job to Solve 4 Problems 

* 1) Top 5 (per capita) violent crimes
```console
val top5violentCrimes = violentData.map(i => (i._2,1)).reduceByKey(_ + _)
val result = top5violentCrimes.sortBy(_._2, false).take(5).
  map(i => (i._1, descOf(i._1), i._2, i._2/272.0))
sc.parallelize(result).
  toDF("IUCR","DESCRIPTION OF IUCR","COUNT","PER 10,000 (2.72 millions)").
  show
```
The result is ...

IUCR|DESCRIPTION OF IUCR|COUNT|PER 10,000 (2.72 millions)
---|---|---|---
0430|BATTERY AGGRAVATED: OTHER DANG WEAPON|62683|230.45220588235293
051A|ASSAULT AGGRAVATED: HANDGUN|37690|138.56617647058823
041A|BATTERY AGGRAVATED: HANDGUN|30256|111.23529411764706
0520|ASSAULT AGGRAVATED:KNIFE/CUTTING INSTR|25533|93.87132352941177
0420|BATTERY AGGRAVATED:KNIFE/CUTTING INSTR|24423|89.7904411764706

* 2) Top 5 (per capita) non-violent crimes
```console
val top5nonViolentCrimes = nonViolentData.map(i => (i._2,1)).reduceByKey(_ + _)
val result = top5nonViolentCrimes.sortBy(_._2, false).take(5).
  map(i => (i._1, descOf(i._1), i._2, i._2/272.0))
sc.parallelize(result).
  toDF("IUCR","DESCRIPTION OF IUCR","COUNT","PER 10,000 (2.72 millions)").
  show
```

The result is ...

IUCR|DESCRIPTION OF IUCR|COUNT|PER 10,000 (2.72 millions)
---|---|---|---
0820|THEFT $300 AND UNDER|478046|1757.5220588235295
0460|BATTERY SIMPLE|457404|1681.6323529411766
0486|BATTERY DOMESTIC BATTERY SIMPLE|449161|1651.327205882353
1320|CRIMINAL DAMAGE TO VEHICLE|323388|1188.9264705882354
1310|CRIMINAL DAMAGE TO PROPERTY|316439|1163.3786764705883

* 3) Top 5 (per capita) locations with violent crimes
```console
val top5violentLocs = violentData.map(i => (i._1,1)).reduceByKey(_ + _)
val result = top5violentLocs.sortBy(_._2, false).take(5).
  map(i => (i._1, i._2, i._2/272.0))
sc.parallelize(result).
  toDF("LOCATION(BLOCK)","COUNT","PER 10,000 (2.72 millions)").
  show
```

The result is ...

LOCATION(BLOCK)|COUNT|PER 10,000 (2.72 millions)
---|---|---
064XX S DR MARTIN LUTHER KING JR DR|264|0.9705882352941176
063XX S DR MARTIN LUTHER KING JR DR|262|0.9632352941176471
006XX W DIVISION ST|197|0.7242647058823529
023XX S STATE ST|191|0.7022058823529411
049XX S STATE ST|162|0.5955882352941176

* 4) Top 5 (per capita) locations with non-violent crimes
```console
val top5nonViolentLocs = nonViolentData.map(i => (i._1,1)).reduceByKey(_ + _)
val result = top5nonViolentLocs.sortBy(_._2, false).take(5).
  map(i => (i._1, i._2, i._2/272.0))
sc.parallelize(result).
  toDF("LOCATION(BLOCK)","COUNT","PER 10,000 (2.72 millions)").
  show
```

The result is ...

LOCATION(BLOCK)|COUNT|PER 10,000 (2.72 millions)
---|---|---
100XX W OHARE ST|14360|52.794117647058826
001XX N STATE ST|9692|35.63235294117647
076XX S CICERO AVE|8414|30.933823529411764
008XX N MICHIGAN AVE|6932|25.485294117647058
0000X N STATE ST|6717|24.69485294117647


---

### You can watch the demo video : https://asciinema.org/a/37866
