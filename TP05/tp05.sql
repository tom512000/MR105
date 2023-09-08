-- Ouverture du fichier de trace
SPOOL tp05.lst

-- R1 : Liste des clients (nom et numéro de téléphone) qui sont des collectivités publiques (typeClt = '03') de la ville de REIMS.
SELECT nomClt "Client", telClt "Numéro de téléphone"
FROM repas.Client
WHERE typeClt = '03'
AND UPPER(villeClt) = 'REIMS'
ORDER BY 1;

-- R2 : Liste des menus contenant le mot « HAWAI » ainsi que les menus de type traditionnel (typeMenu 4). Tri par ordre alphabétique du libellé de menu.
SELECT libMenu "Libellé de Menu"
FROM repas.Menu
WHERE UPPER(libMenu) LIKE '%HAWAI%'
OR typeMenu = '4'
ORDER BY 1;

-- R3 : Liste des éléments de menus dont le nombre de calories (nbCalories) est compris entre 50 et 100 et dont soit le prix unitaire prévu (puPrévu) est inférieur à 1€ soit le coût de revient (coutRevient) est inférieur à 1.50€
SELECT libEltMenu "Libellé Elément Menu"
FROM repas.ElementMenu
WHERE (nbCalories BETWEEN 50 AND 100)
AND (puPrevu < 1)
AND (coutRevient < 1.50);

-- Permet de ne pas répéter les éléments
BREAK ON "Ville Client" SKIP 1

-- Compter le nombre de clients pour chacune des villes
COMPUTE COUNT LABEL 'Nombre de client' OF "Nom Client" ON "Ville Client"

-- R4 : vListe des clients qui sont soit des comités d’entreprise (typeClt 01) soit des collectivités publiques (typeClt 03) mais qui sont, dans tous les cas, sans parrain (NULL) et localisés dans la Marne (51). Tri et rupture sur la ville.
SELECT nomClt "Nom Client", villeClt "Ville Client", TO_CHAR (dateClt, 'month YYYY') "Date Client", CPclt
FROM repas.Client
WHERE (typeClt = '01'
OR typeClt = '03')
AND numParrain IS NULL
AND CPClt LIKE '51%'
ORDER BY 2;

-- Suppression de tous les COMPUTES
CLEAR COMPUTES

-- Suppression de tous les BREAK
CLEAR BREAKS

-- R5 : Liste des clients qui sont : - Soit des municipalités (typeClt = '02') dont le nom commence par COM, clients depuis au moins 2000 (dateClt) et ayant un parrain (numParrain IS NOT NULL), - Soit des collectivités publiques (typeClt = '03') localisées à VAUCIENNES, AY ou SEZANNE (villeClt) et dont le nom (nomClt) contient le mot 'Communaute'.
SELECT nomClt "Client", DECODE(typeClt, '02', 'Municipalite', '03', 'Collectivite') "Type Client", TO_CHAR(dateClt, 'DD Month YYYY') "Client depuis", cpClt||' '||villeClt "Localisation"
FROM repas.Client
WHERE (typeClt = '02'
AND villeClt LIKE 'COM%'
AND EXTRACT(YEAR FROM dateClt) >= 2000
AND numParrain IS NOT NULL)
OR (typeClt = '03'
AND UPPER(villeClt) IN ('VAUCIENNES','AY','SEZANNE')
AND nomClt LIKE '%Communaute%')
ORDER BY 2, 3 DESC;

-- Fermeture du fichier de trace
SPOOL OFF