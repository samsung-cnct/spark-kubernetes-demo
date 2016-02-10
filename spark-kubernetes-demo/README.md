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

## Step 1) 

Load Dataset

* import
```console
> import xxx
```

## Step 2)

Run Spark-job

* 1) Top 5 violent crimes
```console
> val violentDf = 
```


---
* You can watch the demo video : https://asciinema.org/a/36097
