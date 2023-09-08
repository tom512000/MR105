REM ----- Variables d'environnement positionnees au demarrage -----.
REM       login.sql
-- les variables d'environnment permettent de paramètrer une session SQLPLUS
-- l'affectation d'une variable se fait grâce à l'instruction SET
-- la commande SHOW permet ensuite de visualiser l'état des variables d'environnement 

-- pas de séparateur 
set recsep off

-- Définition de la taille d'une ligne de résultats (en caractères) et d'une page de résultats (en lignes) 
set linesize 200
set pagesize 100

set wrap off
set verify on
set pause off

-- permet d'afficher les commande avant de les exécuter
set echo on
