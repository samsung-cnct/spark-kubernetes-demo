# Spark Demo on Kubernetes

## Overview

This project is for the demo of the apache spark on kuberntes

The demo is a real world Spark/Kubernetes example using Chicago crime [data](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2)

The missions are ...

> Top 5 violent crimes

> Top 5 non-violent crimes

> Top 5 locations with violent crimes

> Top 5 locations with non-violent crimes

 * You can download the data via ...
```console
curl -v -o chicago_crime.csv https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv\?accessType\=DOWNLOAD
```

## Step One: Preparation

* Before you start, below configuration setting is needed

```console
export KUBERNETES_PROVIDER=aws
export MASTER_SIZE=t2.small
export MINION_SIZE=t2.small
export NUM_MINIONS=8
```

* Start kubernetes

```console
kube-up.sh
```

* Start spark-cluster
```console
kubectl.sh create -f spark-master-service.yaml
kubectl.sh create -f spark-master-controller.yaml
kubectl.sh create -f spark-worker-controller.yaml
```

* Start spark-shell
```console
kubectl.sh run spark-shell -i -tty \
  --image="nohkwangsun/spark-shell:latest" \
  --env="SPARK_EXECUTOR_MEMORY=1g"
```

## Step Two: Load a Chicago Crime Dataset

* Before we start, we should import packages to make the schema info of the dataset
```console
import org.apache.spark.sql.types.{StructType,StructField,StringType};
import org.apache.spark.sql.Row;
```

* Load Chicago crime dataset from S3

> You can't read data from S3 using Hadoop 2.6 prebuilt pacakge.
> So, if you want to run this example on kubernetes,
> you have to make your own images or use thease images that I made already.
> https://issues.apache.org/jira/browse/SPARK-7442

```console
val text = sc.textFile("chicago_crime.csv")
text.partitions.size
```


* Make a schema from the dataset
```console
val header = text.first
val schema = StructType(
                header.split(",",22).map(fieldName => StructField(fieldName, StringType, true))
             )
```

* Make a rdd from the dataset
```console
val rdd = text.filter(i => i!=header).map(i => Row(i.split(",",22):_*))
```

* Make a dataframe with Rdd, Schema
```console
val df = sqlContext.createDataFrame(rdd,schema)

df.printSchema
```

* Load violent crime code from S3
```console
val textOfViolentType = sc.textFile("violent_crime.csv")
val arrayVT = textOfViolentType.map(i => i.split(",",2)(0)).collect
```

* Make a broadcast variable to increase performance
```console
val violentTypeVar = sc.broadcast(arrayVT)
```

* Finally, we can make a crime datafrmae
```console
val crimeDf = df.select($"IUCR",
                     $"Block",
                     ($"IUCR".in(violentTypeVar.value.map(lit(_)):_*)).as("Violent"))
crimeDf.cache
crimeDf.printSchema
```

## Step Three: Run Spark-Job to Solve 4 Problems 

* 1) Top 5 violent crimes
```console
val violentDf = crimeDf.filter($"Violent" === true)
violentDf.cache
val resultOfVC = violentDf.groupBy("IUCR").count.sort($"count".desc)
resultOfVC.show(5)
```

* 2) Top 5 locations with violent
```console
val resultOfVL = violentDf.groupBy("Block").count.sort($"count".desc)
resultOfVL.show(5)
```

* 3) Top 5 non-violent crimes
```console
val nonViolentDf = crimeDf.filter($"Violent" === false)
nonViolentDf.cache
val resultOfNC = nonViolentDf.groupBy("IUCR").count.sort($"count".desc)
resultOfNC.show(5)
```

* 4) Top 5 locations with non-violent crimes
```console
val resultOfNL = nonViolentDf.groupBy("Block").count.sort($"count".desc)
resultOfNL.show(5)
```


---

* The example for spark join
```console
val crimeDesc = sc.textFile("crime_description.csv") 
val crimeDescDf = crimeDesc.map(i => i.split(",")).map(i => (i(0),i(1))).toDF("IUCR", "Description")
resultOfVC.join(crimeDescDf, resultOfVC("IUCR") === crimeDescDf("IUCR")).sort($"count".desc).show
resultOfNC.join(crimeDescDf, resultOfNC("IUCR") === crimeDescDf("IUCR")).sort($"count".desc).show
```


## The Results are ...

**Top 5 violent crimes**

IUCR|count|Description
---|---|---
0430|62683|BATTERY AGGRAVATED: OTHER DANG WEAPON
051A|37690|ASSAULT AGGRAVATED: HANDGUN
041A|30256|BATTERY AGGRAVATED: HANDGUN
0520|25533|ASSAULT AGGRAVATED:KNIFE/CUTTING INSTR
0420|24423|BATTERY AGGRAVATED:KNIFE/CUTTING INSTR

**Top 5 locations with violent crimes**

Block|count|
---|---
064XX S DR MARTIN LUTHER KING JR DR|  264
063XX S DR MARTIN LUTHER KING JR DR|  262
006XX W DIVISION ST|  197
023XX S STATE ST|  191
049XX S STATE ST|  162

**Top 5 non-violent crimes**

IUCR| count|Description
---|---|---
0820|478046|THEFT $300 AND UNDER
0460|457404|BATTERY SIMPLE
0486|449161|BATTERY DOMESTIC BATTERY SIMPLE
1320|323388|CRIMINAL DAMAGE TO VEHICLE
1310|316439|CRIMINAL DAMAGE TO PROPERTY

**Top 5 locations with non-violent crimes**

Block|count
---|---
100XX W OHARE ST|14360
001XX N STATE ST| 9692
076XX S CICERO AVE| 8414
008XX N MICHIGAN AVE| 6932
0000X N STATE ST| 6717


---

### You can watch the demo video : https://asciinema.org/a/36097
