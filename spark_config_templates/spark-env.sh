#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is sourced when running Spark shell commands like spark-shell or spark-submit.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options read when launching programs locally with
# ./bin/run-example or ./bin/spark-submit
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public dns name of the driver program

# Options read by executors and drivers running inside the cluster
# - SPARK_CONF_DIR, Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_EXECUTOR_CORES, Number of cores for the executors (Default: 1 in YARN mode, all available cores in standalone mode)
# - SPARK_EXECUTOR_MEMORY, Memory per Executor (e.g. 1000M, 2G) (Default: 1G)
# - SPARK_DRIVER_MEMORY, Memory for Driver (e.g. 1000M, 2G) (Default: 1G)
# - SPARK_DAEMON_MEMORY, Memory for property loader. (Default: 1g)

# ----- Lignes à décommenter et adapter ----- #

# 1. Spécifier le chemin vers Java (ESSENTIEL)
# Assurez-vous que ce chemin correspond à votre installation Java (JDK 8 ou 11 recommandé pour Hadoop 3/Spark 3)
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# 2. Indiquer à Spark où trouver la configuration Hadoop (ESSENTIEL si utilisation HDFS/YARN)
# Cela permet à Spark de lire core-site.xml, hdfs-site.xml, etc. et de communiquer avec HDFS/YARN.
# export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop

# 3. Ajouter le classpath Hadoop pour que Spark trouve les classes HDFS/YARN (ESSENTIEL si utilisation HDFS/YARN)
# export SPARK_DIST_CLASSPATH=$(hadoop classpath)

# 4. Options pour le mode Standalone (si vous n'utilisez PAS YARN comme master)
# export SPARK_MASTER_HOST=localhost # Adresse IP ou hostname du master Spark
# export SPARK_WORKER_CORES=2        # Nombre de coeurs par worker
# export SPARK_WORKER_MEMORY=2g      # Mémoire par worker
# export SPARK_WORKER_INSTANCES=1    # Nombre de workers sur cette machine

# 5. Options pour l'historique des applications Spark (nécessite configuration dans spark-defaults.conf aussi)
# export SPARK_HISTORY_OPTS="-Dspark.history.fs.logDirectory=hdfs://localhost:9000/spark-history"
# Assurez-vous que le répertoire HDFS existe (hdfs dfs -mkdir /spark-history) et que le History Server est lancé (start-history-server.sh)

# ----- Fin des lignes à adapter ----- #

