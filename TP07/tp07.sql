-- Ouverture du fichier de trace
SPOOL tp07.lst


-- R12 : Liste des clients ayant déjà commandé un menu dont le libellé contient BL comme 6ème et 7ème lettres. Ne pas afficher les doublons.
SELECT DISTINCT nomClt "Client", ROUND ((MONTHS_BETWEEN (SYSDATE, dateClt))/12) "Client depuis"
FROM repas.Client CL, repas.Contrat CO, repas.DetailContrat D, repas.Menu M
WHERE CL.numClt = CO.numClt
AND CO.numCtr = D.numCtr
AND D.numMenu = M.numMenu
AND libMenu LIKE '_____BL%';

-- R13 : Liste les clients ayant une adresse de livraison qui ont souscrit déjà au moins un contrat. Tri des clients par ordre alphabétique.
-- Syntaxe classique
SELECT DISTINCT nomClt "Client"
FROM repas.Client CL, repas.Contrat CO
WHERE CL.numClt = CO.numClt
AND adrLiv IS NOT NULL
ORDER BY 1;

-- Avec INNER JOIN :
SELECT DISTINCT nomClt "Client"
FROM repas.Client CL INNER JOIN repas.Contrat CO ON (CL.numClt = CO.numClt)
WHERE CL.numClt = CO.numClt
AND adrLiv IS NOT NULL
ORDER BY 1;

-- R14 : Liste de tous les clients ayant une adresse de livraison et leur(s) éventuels(s) contrat(s). Les clients sans contrat doivent apparaître. Tri des clients par ordre alphabétique.
-- a) Synthaxe normale
SELECT nomClt "Client", numCtr "Contrat", TO_CHAR (dateCtr,'MON YYYY') "Date Contrat"
FROM repas.Client Cl, repas.Contrat Co
WHERE Cl.numClt = Co.numClt(+)
AND adrLiv IS NOT NULL
ORDER BY 1;

-- b) Modifier la requête pour qu’elle affiche «-----------------» dans la colonne Date Contrat pour les clients sans contrat (Utiliser la fonction NVL).
SELECT nomClt "Client", numCtr "Contrat", NVL(TO_CHAR (dateCtr,'MON YYYY'), '-----------------') "Date Contrat"
FROM repas.Client Cl, repas.Contrat Co
WHERE Cl.numClt = Co.numClt(+)
AND adrLiv IS NOT NULL
ORDER BY 1;

-- c) Modifier la requête pour qu’elle affiche, dans la colonne Contrat, « N° » suivi du numéro de contrat (numCtr) ou « Pas de contrat » pour les clients sans contrat. 
SELECT nomClt "Client", NVL2(numCtr, 'N*'||numCtr, 'Pas de contrat') "Contrat", NVL(TO_CHAR (dateCtr,'MON YYYY'), '-----------------') "Date Contrat"
FROM repas.Client Cl, repas.Contrat Co
WHERE Cl.numClt = Co.numClt(+)
AND adrLiv IS NOT NULL
ORDER BY 1;

-- d) 1. Refaire la requête en utilisant la syntaxe RIGHT JOIN.
SELECT nomClt "Client", NVL2(numCtr, 'N*'||numCtr, 'Pas de contrat') "Contrat", NVL(TO_CHAR (dateCtr,'MON YYYY'), '-----------------') "Date Contrat"
FROM repas.Contrat Co RIGHT JOIN repas.Client Cl ON (Cl.numClt = Co.numClt)
WHERE adrLiv IS NOT NULL
ORDER BY 1;

-- d) 2. Refaire la requête en utilisant la syntaxe LEFT JOIN.
SELECT nomClt "Client", NVL2(numCtr, 'N*'||numCtr, 'Pas de contrat') "Contrat", NVL(TO_CHAR (dateCtr,'MON YYYY'), '-----------------') "Date Contrat"
FROM repas.Client Cl LEFT JOIN repas.Contrat Co ON (Cl.numClt = Co.numClt)
WHERE adrLiv IS NOT NULL
ORDER BY 1;


-- R15 : a) Liste des éléments de menu d’une catégorie dont le libellé est saisi par l’utilisateur (par ex. ENTREE) avec les menus dans lesquels ils apparaissent. Tri dans l’ordre alphabétique des éléments.
PROMPT "Donner la variable de Menu"
ACCEPT menuprompt

SELECT libEltMenu "Element menu", libMenu "Menu"
FROM repas.ElementMenu E, repas.Categorie Ca, repas.Composition Co, repas.Menu M
WHERE Ca.numCatg = E.numCat
AND E.numElt = Co.numElt
AND Co.numMenu = M.numMenu
AND UPPER(libCatg) = '&menuprompt'
ORDER BY 1;

-- b) Modifier la requête pour qu’elle affiche tous les éléments de menus de la catégorie choisie même ceux qui n’apparaissent dans aucun menu. La colonne Menu devra contenir « AUCUN MENU » pour les éléments non utilisés dans un menu.
PROMPT "Donner la variable de Menu"
ACCEPT menuprompt

SELECT DISTINCT libEltMenu "Element menu", NVL(libMenu, 'AUCUN MENU') "Menu"
FROM repas.ElementMenu E, repas.Categorie Ca, repas.Composition Co, repas.Menu M
WHERE Ca.numCatg = E.numCatg
AND E.numElt = Co.numElt(+)
AND Co.numMenu = M.numMenu(+)
AND UPPER(libCatg) = '&menuprompt'
ORDER BY 1;

-- R16 : Liste des éléments de menu qui n’apparaissent dans aucun menu.
SELECT libEltMenu "Element menu"
FROM repas.ElementMenu E, repas.composition C, repas.Menu M
WHERE E.numElt = C.numElt(+)
AND C.numMenu = M.numMenu(+)
AND libMenu IS NULL;

-- Fermeture du fichier de trace
SPOOL OFF