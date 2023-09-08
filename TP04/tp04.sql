-- Ouverture du fichier de trace
SPOOL tp04.lst

-- Commande SQL*PLUS
COL libEltMenu FORMAT A30 HEADING "Element Menu"

-- Envoie un message d'information
PROMPT "Donner la variable de nbcal"

-- Affecter à la variable de substitution
ACCEPT nbcal 

-- Cette requête permet d'afficher la 
SELECT libEltMenu
FROM REPAS.elementMenu
WHERE nbCalories > &nbcal
ORDER BY 1;

-- Fermeture du fichier de trace
SPOOL OFF