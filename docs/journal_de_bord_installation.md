# Journal de Bord d'Installation

## Informations Générales

- **Date de début** : 29/5/2025
- **Serveur utilisé** : Ubuntu Server 22.04 LTS – salle E26
- **Objectif** : Mise en place d’un environnement Big Data stable avec Hadoop & Spark (mode pseudo-distribué)

---

## Étapes Réalisées

### 1. Configuration Initiale du Serveur

- Mise à jour système :
  ```bash
  sudo apt update && sudo apt upgrade -y
  ```
- SSH :
  - Port modifié : `2222`
  - Authentification par clé activée
  - Authentification par mot de passe désactivée
  - Connexion root désactivée
- Comptes utilisateurs créés :
  - `etudiantA`, `etudiantB`, `etudiantC` (ajoutés au groupe sudo)
- Pare-feu UFW configuré :
  ```bash
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow 2222/tcp
  sudo ufw allow OpenSSH
  sudo ufw enable
  ```
- Nom d’hôte configuré :
  - Hostname : `serveur-bigdata`
  - `/etc/hosts` mis à jour

---

### 2. Installation de Java

- Version installée : OpenJDK 11
  ```bash
  sudo apt install openjdk-11-jdk -y
  ```
- JAVA_HOME défini :
  ```bash
  export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
  ```

---

### 3. Installation de Hadoop

- Version installée : Hadoop 3.3.6
- Répertoire : `~/hadoop`
- Variables d’environnement :
  - `HADOOP_HOME`, `PATH`, `HADOOP_CONF_DIR`, etc.
- Fichiers de configuration modifiés :
  - `hadoop-env.sh` → JAVA_HOME défini
  - `core-site.xml` → fs.defaultFS = hdfs://localhost:9000
  - `hdfs-site.xml` → chemins NameNode/DataNode, réplication = 1
  - `mapred-site.xml` → framework = yarn
  - `yarn-site.xml` → resource manager = localhost
- Répertoires HDFS créés :
  ```bash
  mkdir -p ~/hadoop_data/hdfs/namenode
  mkdir -p ~/hadoop_data/hdfs/datanode
  ```

---

### 4. Installation de Spark

- Version installée : Spark 3.5.1 (Hadoop 3.x compatible)
- Répertoire : `~/spark`
- Variables d’environnement :
  ```bash
  export SPARK_HOME=~/spark
  export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
  ```
- Fichiers modifiés :
  - `spark-env.sh` → JAVA_HOME et SPARK_DIST_CLASSPATH
  - `spark-defaults.conf` (optionnel)

---

### 5. Configuration du Cluster (Pseudo-distribué)

- SSH sans mot de passe vers localhost configuré :
  ```bash
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  chmod 0600 ~/.ssh/authorized_keys
  ```
- Formatage du NameNode HDFS :
  ```bash
  hdfs namenode -format
  ```
- Démarrage des services Hadoop :
  ```bash
  start-dfs.sh
  start-yarn.sh
  ```
- Vérification avec `jps` :
  - NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager visibles

---

### 6. Accès Interfaces Web

- HDFS NameNode UI : http://localhost:9870
- YARN ResourceManager UI : http://localhost:8088
- Spark Master UI (si standalone activé) : http://localhost:8080

---

### 7. Dépôt Git

- Dépôt créé : bigdata-project
- Structure initiale :
  ```
  /docs
  /scripts
  /config/hadoop
  /config/spark
  /data/raw
  ```
- Fichier présent : `docs/journal_de_bord_installation.md`
- Fichiers ignorés : `.gitignore` avec :
  ```
  hadoop_data/
  logs/
  *.pyc
  __pycache__/
  ```


---

## Décisions de Configuration

- Utilisation de JAVA 11 (compatible Hadoop 3.x, Spark 3.5.1)
- Mode pseudo-distribué
- Utilisation de YARN comme gestionnaire de ressources pour Spark

---

## Versions Logiciels

- Ubuntu : 22.04 LTS
- Java : OpenJDK 11
- Hadoop : 3.3.6
- Spark : 3.5.1
