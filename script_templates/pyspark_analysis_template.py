#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Template de script PySpark pour analyse de données
# À adapter et utiliser par l'Étudiant C (et potentiellement B pour des traitements)

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, avg, count # Importez les fonctions nécessaires
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType # Pour définir le schéma

# --- Configuration ---
APP_NAME = "MonAnalyseSpark"

# Chemin HDFS vers les données d'entrée (à adapter)
# Exemple: "/projet_bigdata/data_brute/mon_dataset/fichier.csv"
# Exemple: "/projet_bigdata/data_traitee/dataset_prepare_par_B"
INPUT_DATA_PATH = "hdfs:///projet_bigdata/data_brute/VOTRE_FICHIER_OU_DOSSIER"

# Format des données d'entrée (csv, json, parquet, etc.)
INPUT_DATA_FORMAT = "csv"

# Options de lecture (spécifiques au format)
# Pour CSV: header, inferSchema, sep, schema
# Pour JSON: multiLine
INPUT_OPTIONS = {
    "header": "true",
    # "inferSchema": "true", # Préférer définir le schéma explicitement
    # "sep": ","
}

# Schéma explicite (RECOMMANDÉ pour CSV/JSON)
# Adaptez les noms de colonnes et les types
# INPUT_SCHEMA = StructType([
#     StructField("colonne1", StringType(), True),
#     StructField("colonne2", IntegerType(), True),
#     StructField("colonne3", DoubleType(), True),
# ])
INPUT_SCHEMA = None # Mettre None si inferSchema=true ou si format Parquet

# Chemin HDFS pour sauvegarder les résultats (à adapter)
OUTPUT_DATA_PATH = "hdfs:///projet_bigdata/resultats_analyse/mon_resultat"

# Format de sortie (parquet recommandé)
OUTPUT_FORMAT = "parquet"

# Mode d'écriture (overwrite, append, ignore, errorifexists)
OUTPUT_MODE = "overwrite"
# --- Fin Configuration ---

def main():
    # 1. Création de la SparkSession
    print(f"Initialisation de SparkSession pour l'application : {APP_NAME}")
    spark = SparkSession.builder \
        .appName(APP_NAME) \
        .getOrCreate() # .config(...) pour ajouter des confs spécifiques si besoin

    # 2. Lecture des données
    print(f"Lecture des données depuis : {INPUT_DATA_PATH} (Format: {INPUT_DATA_FORMAT})")
    try:
        reader = spark.read.format(INPUT_DATA_FORMAT).options(**INPUT_OPTIONS)
        if INPUT_SCHEMA:
            reader = reader.schema(INPUT_SCHEMA)

        df = reader.load(INPUT_DATA_PATH)

        print("Schéma du DataFrame lu :")
        df.printSchema()
        print("Aperçu des données (5 premières lignes) :")
        df.show(5, truncate=False)
        print(f"Nombre de lignes lues : {df.count()}")

    except Exception as e:
        print(f"Erreur lors de la lecture des données depuis {INPUT_DATA_PATH}: {e}")
        spark.stop()
        exit(1)

    # 3. Traitements / Analyse (Exemple : Nettoyage simple et agrégation)
    print("Début des traitements...")

    # Exemple de nettoyage : Supprimer lignes avec nulls dans une colonne clé
    # df_cleaned = df.na.drop(subset=["colonne_cle"])
    df_cleaned = df # Pas de nettoyage dans ce template simple

    # Exemple d'agrégation : Calculer la moyenne d'une colonne par catégorie
    # Assurez-vous que les colonnes "categorie" et "valeur_numerique" existent et sont correctes
    # try:
    #     df_agg = df_cleaned.groupBy("categorie") \
    #         .agg(
    #             avg("valeur_numerique").alias("moyenne_valeur"),
    #             count("*").alias("nombre_elements")
    #         ) \
    #         .orderBy(col("moyenne_valeur").desc())
    #
    #     print("Résultat de l'agrégation :")
    #     df_agg.show(truncate=False)
    #     df_result = df_agg # Le DataFrame à sauvegarder est le résultat de l'agrégation
    #
    # except Exception as e:
    #     print(f"Erreur lors de l'agrégation (vérifiez les noms de colonnes): {e}")
    #     df_result = df_cleaned # Sauvegarder le DF nettoyé si l'agrégation échoue

    # Pour ce template, on sauvegarde le DataFrame lu directement (ou nettoyé)
    df_result = df_cleaned

    # 4. Sauvegarde des résultats
    print(f"Sauvegarde des résultats dans : {OUTPUT_DATA_PATH} (Format: {OUTPUT_FORMAT}, Mode: {OUTPUT_MODE})")
    try:
        # coalesce(1) peut être utile pour obtenir un seul fichier en sortie (CSV/JSON), mais attention à la mémoire
        # Pour Parquet, il est généralement préférable de laisser Spark gérer le nombre de fichiers.
        writer = df_result.write.format(OUTPUT_FORMAT).mode(OUTPUT_MODE)
        # if OUTPUT_FORMAT in ["csv", "json"]:
        #     writer = df_result.coalesce(1).write.format(OUTPUT_FORMAT).mode(OUTPUT_MODE).option("header", "true")

        writer.save(OUTPUT_DATA_PATH)
        print("Sauvegarde réussie.")

    except Exception as e:
        print(f"Erreur lors de la sauvegarde des résultats dans {OUTPUT_DATA_PATH}: {e}")

    # 5. Arrêt de la SparkSession
    print("Arrêt de SparkSession.")
    spark.stop()

if __name__ == "__main__":
    main()

