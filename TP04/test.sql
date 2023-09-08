-- Ceci est un commentaire
/* Pour utiliser celui la n'oubliez pas de le faire suivre d'un espace */

-- Ouverture du fichier de trace
SPOOL test

-- Description de la table CLIENT  du schema REPAS
DESC REPAS.CLIENT

-- Formatage des colonnes
COL NOMCLT 	FORMAT A35 	HEADING CLIENT
COL VILLECLT 	FORMAT A20 	HEADING VILLE
COL ADRCLT 	FORMAT A25 	HEADING ADRESSE
COL CPCLT 	FORMAT A11  	HEADING "CODE POSTAL"
COL NUMCLT 	FORMAT A15  	HEADING "NUMERO CLIENT"
COL TELCLT 	FORMAT A10  	HEADING "TELEPHONE"

/* ****************************** */
-- Affichage des clients de REIMS
/* ****************************** */
-- Le symbole * permet d'extraire toutes les colonnes de la table. 
-- Il n'est utilisé que pour des tests ou démonstration mais ni en développemnt ni en production

SELECT * 
FROM REPAS.CLIENT
WHERE villeclt = 'REIMS';

-- Fermeture du fichier de trace
SPOOL OFF
