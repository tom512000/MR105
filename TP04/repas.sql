-- Ouverture du fichier de trace
SPOOL repas.lst

-- Affiche les paramètres de la table Menu
-- DESC Repas.Menu

-- Affiche les paramètres de la table Client
-- DESC Repas.Client

-- Commande de formatage SQL*PLUS
COL numMenu FORMAT A30 HEADING "Numéro de Menu"
COL libMenu FORMAT A30 HEADING "Libellé de Menu"
COL typeMenu FORMAT A30 HEADING "Type de Menu"

-- Requête 1 : Affiche toutes les données de la table Menu
SELECT *
FROM Repas.Menu;

-- Permet de ne pas répéter la ville
BREAK ON "Ville client" ON REPORT

-- Compter le nombre de clients pour chacune des villes
COMPUTE COUNT LABEL 'Nombre de client' OF "Nom Client" ON "Ville client" REPORT

-- Requête 2 : Affiche le contenu de la table CLIENT trié par ordre alphabétique sur la ville
SELECT villeclt as "Ville client", nomClt as "Nom Client"
FROM Repas.Client
ORDER BY 1;

-- Envoie un message d'information
PROMPT "Donner un nom de ville (villevar)"

-- Affecter à la variable de substitution
ACCEPT villevar

-- Requête 3 : Affiche le contenu de la table CLIENT trié par ordre alphabétique sur la ville
SELECT villeclt as "Ville client", nomClt as "Nom Client"
FROM Repas.Client
WHERE UPPER(VilleClt) = UPPER(&villevar)
ORDER BY 1;

-- Suppression de tous les COMPUTES
CLEAR COMPUTES

-- Suppression de tous les BREAK
CLEAR BREAKS

-- Fermeture du fichier de trace
SPOOL OFF