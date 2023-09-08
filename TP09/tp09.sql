-- Ouverture du fichier de trace
SPOOL tp09.lst
/*
-- R23 : Liste des éléments de menus de la catégorie FROMAGE. Tri sur Bénéfice décroissant. A faire avec une sous-requête.
SELECT libEltMenu "Element", nbCalories "Nb calories", coutRevient "Cout Revient", puPrevu "Prix Unitaire", puPrevu-coutRevient "Benefice"
FROM repas.ElementMenu
WHERE numCatg = (SELECT numCatg
                FROM repas.Categorie
                WHERE UPPER(libCatg) = 'FROMAGE')
ORDER BY 5 DESC;

-- R24 : Liste des menus qui ne sont pas de type EXPRESS (typeMenu 1) et qui ont fait l'objet d'au moins un contrat.
-- a) Avec jointure
SELECT DISTINCT libMenu
FROM repas.Menu M, repas.DetailContrat D
WHERE M.numMenu = D.numMenu
AND typeMenu != '1';

-- b) Avec sous-requêtes
SELECT DISTINCT libMenu
FROM repas.Menu
WHERE typeMenu != '1'
AND numMenu IN (SELECT numMenu
                FROM repas.DetailContrat);

-- R25 : Liste des menus qui ne sont pas de type EXPRESS (typeMenu 1) et qui n'ont fait l'objet d'aucun contrat.
-- a) Avec jointure
SELECT DISTINCT libMenu
FROM repas.Menu M, repas.DetailContrat D
WHERE M.numMenu = D.numMenu(+)
AND typeMenu != '1'
AND numCtr IS NULL;

-- b) Avec sous-requêtes
SELECT DISTINCT libMenu
FROM repas.Menu
WHERE typeMenu != '1'
AND numMenu NOT IN (SELECT numMenu
                FROM repas.DetailContrat);

-- R26 : Liste des éléments de menus qui composent le menu dont le libellé se termine par le mot PEKIN. N'utiliser que des sous-requêtes.
SELECT libEltMenu "Element"
FROM repas.ElementMenu
WHERE numElt IN (SELECT numElt
                 FROM repas.Composition
                 WHERE numMenu IN (SELECT numMenu
                                   FROM repas.Menu
                                   WHERE UPPER(libMenu) LIKE '%PEKIN'));

-- R27 : Liste des éléments de menus (libEltMenu) avec leur catégorie (libCatg), fournis par le fournisseur nommé "Le Chef Propose". Tri par catégorie puis par élément de menu.

-- a) Pourquoi ne peut-on pas utiliser que des sous-requêtes pour faire cette requête ?
-- On ne peut pas utiliser des sous-requêtes pour faire cette requête car les attributs libCatg et libEltMenu ne sont pas issues de la même table. 

-- c) Ecrire la requête SQL correspondante
SELECT DISTINCT libEltMenu "Element", C.libCatg "Categorie"
FROM repas.ElementMenu E, repas.Categorie C
WHERE E.numCatg = C.numCatg
AND numElt IN (SELECT numElt
               FROM repas.Fournir
               WHERE numFourn IN (SELECT numFourn
                                  FROM repas.Fournisseur
                                  WHERE nomFourn = 'Le Chef Propose'))
ORDER BY 2, 1;

-- d) Faire une seconde version de la requête SQL en n'utilisant que des jointures.
SELECT DISTINCT libEltMenu "Element", libCatg "Categorie"
FROM repas.ElementMenu E, repas.Categorie C, repas.Fournir Fir, repas.Fournisseur Feur
WHERE E.numCatg = C.numCatg
AND E.numElt = Fir.numElt
AND Fir.numFourn = Feur.numFourn
AND nomFourn = 'Le Chef Propose'
ORDER BY 2, 1;
*/
-- R29 : Liste des éléments de menus de catégorie ENTREE , PLAT ou DESSERT qui composent les différents menus de type exotique (typeMenu 5). Tri par catégorie.
-- a) Ecrire la requête en SQL en n'utilisant que des jointures
--SET COLUMN libCatg NOPRINT
SELECT DISTINCT libEltMenu "Element", libCatg
FROM repas.ElementMenu E, repas.Categorie CA, repas.Composition CO, repas.Menu M
WHERE CA.numCatg = E.numCatg
AND E.numElt = CO.numElt
AND CO.numMenu = M.numMenu
AND UPPER(libCatg) IN ('ENTREE','PLAT','DESSERT')
AND typeMenu = '5'
ORDER BY 2;

-- TRI PAR CATEGORIE IMPOSSIBLE

-- c) Ecrire la requête en SQL en n'utilisant que des sous-requêtes (Opérateurs IN) 
SELECT libEltMenu "Element"
FROM repas.ElementMenu
WHERE numCatg IN (SELECT numCatg
                  FROM repas.Categorie
                  WHERE UPPER(libCatg) IN ('ENTREE','PLAT','DESSERT'))
AND numElt IN (SELECT numElt
               FROM repas.Composition
               WHERE numMenu IN (SELECT numMenu
                                 FROM repas.Menu
                                 WHERE typeMenu = '5'));

-- Fermeture du fichier de trace
SPOOL OFF