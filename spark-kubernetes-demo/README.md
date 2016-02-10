# Spark Demo on Kubernetes

## Overview

This project is for the demo of the apache spark on kuberntes

Dataset:
Goal:

## Step 0

Start kubernetes and spark-cluster

* Before you start, below configuration setting is needed

```console
export KUBERNETES_PROVIDER=aws
export MASTER_SIZE=t2.small
export MINION_SIZE=t2.small
export NUM_MINIONS=8
```

## Step 1

Load a Chicago Crime Dataset

* Before we start, we should import packages to make the schema info of the dataset
```console
import org.apache.spark.sql.types.{StructType,StructField,StringType};
import org.apache.spark.sql.Row;
```

* Load Chicago crime dataset from S3
```console
val text = sc.textFile("chicago_crime.csv")
text.partitions.size
```


* Make a schema from the dataset
```console
val header = text.first
val schema = StructType(  header.split(",",22).map(fieldName => StructField(fieldName, StringType, true))  )
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

## Step 2

Run Spark-Job to Solve 4 Problems 

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


Step 3

* The example for spark join
```console
val crimeDesc = sc.textFile("crime_description.csv") 
val crimeDescDf = crimeDesc.map(i => i.split(",")).map(i => (i(0),i(1))).toDF("IUCR", "Description")
resultOfVC.join(crimeDescDf, resultOfVC("IUCR") === crimeDescDf("IUCR")).sort($"count".desc).show
resultOfNC.join(crimeDescDf, resultOfNC("IUCR") === crimeDescDf("IUCR")).sort($"count".desc).show
```


---

### You can watch the demo video : https://asciinema.org/a/36097
