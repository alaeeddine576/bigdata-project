#!/bin/bash

# Template de script pour uploader des fichiers locaux vers HDFS
# À adapter et utiliser par l'Étudiant B

# --- Configuration ---
# Répertoire local contenant les fichiers à uploader
# Adaptez ce chemin à l'emplacement réel de vos données sur le serveur
LOCAL_DATA_DIR="/home/utilisateur/projet-bigdata-e26/data/raw"

# Répertoire cible dans HDFS
# Adaptez ce chemin à la structure HDFS que vous avez définie
HDFS_TARGET_DIR="/projet_bigdata/data_brute"

# Liste des fichiers à uploader (ajoutez ou modifiez les noms de fichiers)
FILES_TO_UPLOAD=(
  "dataset1.csv"
  "dataset2.json"
  # "un_autre_fichier.txt"
)
# --- Fin Configuration ---

# Vérifier si le répertoire HDFS cible existe, sinon le créer
echo "Vérification du répertoire HDFS cible : $HDFS_TARGET_DIR"
hdfs dfs -test -d $HDFS_TARGET_DIR
if [ $? != 0 ]; then
  echo "Le répertoire n'existe pas. Création de $HDFS_TARGET_DIR..."
  hdfs dfs -mkdir -p $HDFS_TARGET_DIR
  if [ $? != 0 ]; then
    echo "Erreur : Impossible de créer le répertoire HDFS $HDFS_TARGET_DIR. Vérifiez les permissions ou l'état de HDFS."
    exit 1
  fi
else
  echo "Le répertoire HDFS cible existe."
fi

# Boucle sur les fichiers à uploader
for file in "${FILES_TO_UPLOAD[@]}"; do
  local_file_path="$LOCAL_DATA_DIR/$file"
  hdfs_file_path="$HDFS_TARGET_DIR/$file"

  # Vérifier si le fichier local existe
  if [ -f "$local_file_path" ]; then
    echo "Upload de '$file' depuis '$local_file_path' vers '$HDFS_TARGET_DIR'..."
    # Utiliser l'option -f pour écraser le fichier s'il existe déjà dans HDFS
    # Enlevez -f si vous ne voulez pas écraser
    hdfs dfs -put -f "$local_file_path" "$HDFS_TARGET_DIR/"

    # Vérifier si l'upload a réussi (vérification basique)
    if [ $? == 0 ]; then
      echo "Upload de '$file' réussi."
    else
      echo "Erreur : L'upload de '$file' a échoué."
    fi
  else
    echo "Attention : Le fichier local '$local_file_path' n'a pas été trouvé. Upload ignoré."
  fi
done

echo "--- Upload terminé --- "
echo "Contenu actuel de $HDFS_TARGET_DIR :"
hdfs dfs -ls $HDFS_TARGET_DIR

exit 0

