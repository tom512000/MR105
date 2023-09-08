-- Ouverture du fichier de trace
SPOOL tp08.lst

-- R17 : Liste de tous les menus qui ne sont ni de type express (typeMenu 1) ni de type économique (typeMenu 2) avec leurs contrats associés. Les menus associés à aucun contrat doivent apparaître.
SELECT libMenu "Menu", DECODE (typeMenu, '3', 'Allege', '4', 'Traditionnel', '5', 'Exotique') "Type Menu", NVL2(numCtr, ' Contrat N*'||numCtr, 'Pas de contrat') "Contrat"
FROM repas.Menu M, repas.DetailContrat D
WHERE M.numMenu = D.numMenu(+)
AND typeMenu != '1'
AND typeMenu != '2'
ORDER BY 2;

-- R18 : Liste des menus qui ne sont ni de type express ni de type économique mais uniquement ceux pour lesquels il n’y a aucun contrat.
SELECT libMenu "Menu", DECODE (typeMenu, '3', 'Allege', '4', 'Traditionnel', '5', 'Exotique') "Type Menu"
FROM repas.Menu M, repas.DetailContrat D
WHERE M.numMenu = D.numMenu(+)
AND typeMenu != '1'
AND typeMenu != '2'
AND numCtr IS NULL
ORDER BY 2;

-- R19 : Liste des menus de même type que le "MENU HAWAI" (ne pas afficher le menu HAWAI ).
SELECT Ma.libMenu "Menu"
FROM repas.Menu Ma, repas.Menu Mb
WHERE Ma.typeMenu = Mb.typeMenu
AND Mb.libMenu = 'MENU HAWAI'
AND Ma.libMenu != 'MENU HAWAI';

-- R20 : Liste des éléments de menu de la même catégorie que l'élément de menu " PAELLA " mais dont le nombre de calories est inférieur.
BREAK ON "Calories Paella"

SELECT Ea.libEltMenu "Element", Ea.nbCalories "Nb Calories", NVL2(Ea.numElt,'------------','------------') "-------------", Eb.nbCalories "Calories Paella"
FROM repas.ElementMenu Ea, repas.ElementMenu Eb
WHERE Ea.numCatg = Eb.numCatg
AND Ea.nbCalories < Eb.nbCalories
AND Eb.libEltMenu = 'PAELLA';

CLEAR BREAKS

-- R21 : Liste des clients ayant un parrain. Tri sur le nom du parrain, puis sur le nom du client.
SELECT C.nomClt "Client",
    C.CPClt||' - '||C.villeClt "Adresse Client",
    DECODE(C.typeClt,'01','CE','02','M','03','CP') "Type Client",
    P.nomClt "Parrain",
    P.CPClt||' - '||P.villeClt "Adresse Parrain",
    DECODE(P.typeClt,'01','CE','02','M','03','CP') "Type Parrain"
FROM repas.Client C, repas.Client P
WHERE P.numClt = C.numParrain
ORDER BY 4, 1;


-- R22 : Liste de tous les clients même ceux qui n’ont pas de parrain (caractéristiques du parrain éventuellement remplies par des * (étoiles)).
SELECT C.nomClt "Client",
    C.CPClt||' - '||C.villeClt "Adresse Client",
    DECODE(C.typeClt,'01','CE','02','M','03','CP') "Type Client",
    NVL(P.nomClt,'*******************************************') "Parrain",
    NVL2(P.CPClt, P.CPClt||' - '||P.villeClt,'****************************') "Adresse Parrain",
    NVL(DECODE(P.typeClt,'01','CE','02','M','03','CP'),'**') "Type Parrain"
FROM repas.Client C, repas.Client P
WHERE P.numClt(+) = C.numParrain
ORDER BY 4, 1;

-- Fermeture du fichier de trace
SPOOL OFF