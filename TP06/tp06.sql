-- Ouverture du fichier de trace
SPOOL tp06.lst

-- Permet de ne pas répéter les éléments
BREAK ON "Categorie"

-- Compter le nombre de clients pour chacune des villes
COMPUTE COUNT LABEL 'Nombre de calories' OF "Nb Calories" ON "Categorie"

-- R6 :  Liste des éléments de menu des catégories DESSERT, FROMAGE et SALADE, triés par catégorie, par nombre de calories puis par libellé.
SELECT libCatg "Categorie", libEltMenu "Element", nbCalories "Nb Calories"
FROM repas.Categorie C, repas.ElementMenu E
WHERE C.numCatg = E.numCatg
AND UPPER(libCatg) IN ('DESSERT','FROMAGE','SALADE')
ORDER BY 1, 3, 2;

-- Suppression de tous les COMPUTES
CLEAR COMPUTES

-- Suppression de tous les BREAK
CLEAR BREAKS

-- R7 : Liste des clients ayant passé un contrat en mai 2009.
SELECT nomClt "Client", villeClt "Ville", TO_CHAR (dateCtr, 'month YYYY') "Date Contrat"
FROM repas.Client Cl, repas.Contrat Co
WHERE Cl.numClt = Co.numClt
AND TO_CHAR (dateCtr, 'MM/YYYY') = '05/2009';

-- R8 : Liste des éléments de menu de la catégorie DESSERT à servir chaud et ayant un prix unitaire prévu supérieur à 2.50 €.
SELECT libEltMenu "Element Menu"
FROM repas.ElementMenu E, repas.Categorie CA, repas.Composition CO
WHERE E.numCatg = CA.numCatg
AND E.numElt = CO.numElt
AND UPPER(libCatg) = 'DESSERT'
AND servirChaudFroid = 'C'
AND puPrevu > 2.50;

-- R9 : Liste des éléments de menu de la catégorie « ENTREE » qui composent les menus de type 4 (TRADITIONNEL) et 5 (EXOTIQUE), triés par type.
SELECT libEltMenu "Element Menu", libMenu "Menu", DECODE(typeMenu, '4', 'TRADITIONNEL', '5', 'EXOTIQUE') "Type"
FROM repas.Categorie CA, repas.ElementMenu E, repas.Composition CO, repas.Menu M
WHERE CA.numCatg = E.numCatg
AND E.numElt = CO.numElt
AND CO.numMenu = M.numMenu
AND UPPER(libCatg) = 'ENTREE'
AND typeMenu IN ('4', '5')
ORDER BY 3;
-- AND (typeMenu = '4' OR typeMenu = '5')

-- Permet de ne pas répéter les éléments
BREAK ON "Element Menu"

-- R10 : Liste des éléments de menu de la catégorie PLAT qui ont fait l’objet d’un contrat. Ne pas afficher les doublons.
SELECT libEltMenu "Element Menu"
FROM repas.Contrat CON, repas.DetailContrat D, repas.Menu M, repas.Composition COM, repas.ElementMenu E, repas.Categorie CA
WHERE CON.numCtr = D.numCtr
AND D.numMenu = M.numMenu
AND M.numMenu = COM.numMenu
AND COM.numElt = E.numElt
AND E.numCatg = CA.numCatg
AND UPPER(libCatg) = 'PLAT'
AND CON.numCtr IS NOT NULL;

-- Permet de supprimer tous les BREAK
CLEAR BREAKS

-- Permet de ne pas répéter les éléments
BREAK ON "Client" SKIP 1 ON REPORT

-- Permet de calcluler des éléments
COMPUTE COUNT LABEL "Nb Menus" OF "Menu" ON "Client"
COMPUTE SUM LABEL "Nb Menus commandes" OF "Nb total Menus" ON "Client"
COMPUTE COUNT LABEL "Nb Total Menus" OF "Menu" ON REPORT
COMPUTE SUM LABEL "Nb Total Menus commandes" OF "Nb total Menus" ON REPORT

-- R11 : Liste des menus commandés entre le 01/04/2009 et le 30/06/2009 par des clients qui ne sont pas de REIMS.
SELECT DISTINCT nomClt "Client", libMenu "Menu", nbMenu "Nb Menus", nbLiv "Nb Livraisons", NbMenu * nbLiv "Nb total Menus"
FROM repas.Client CL, repas.Contrat CON, repas.DetailContrat D, repas.Menu M
WHERE CL.numClt = CON.numClt
AND CON.numCtr = D.numCtr
AND D.numMenu = M.numMenu
AND dateCtr BETWEEN TO_DATE('01/04/2009', 'DD/MM/YYYY') AND TO_DATE ('30/06/2009', 'DD/MM/YYYY')
AND UPPER(villeClt) != 'REIMS'
ORDER BY 1,2,5;

-- Suppression de tous les COMPUTE
CLEAR COMPUTES

-- Suppression de tous les BREAK
CLEAR BREAKS

-- Fermeture du fichier de trace
SPOOL OFF