-- NIVELL 1

-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:

-- Llistat dels països que estan fent compres.
SELECT DISTINCT country 
FROM company
JOIN transaction
ON (company.id = company_id)
-- WHERE company_id IN (company.id) No es necesario teniendo el ON que iguala lo mismo
ORDER BY country;

-- Des de quants països es realitzen les compres.
SELECT count(DISTINCT country) as NumPais 
FROM company
JOIN transaction
ON (company.id = company_id);

-- Identifica la companyia amb la mitjana més gran de vendes. (Es refereix al valor de les ventes, no el nº)
SELECT company_name as Nombre, round(AVG(amount), 2) as MediaVentas
FROM transaction
JOIN company
ON (company_id = company.id)
GROUP BY company_id
ORDER BY MediaVentas DESC
LIMIT 1;

-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):

-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE country = "Germany");

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT company_name 
FROM company
WHERE id IN (SELECT company_id 
			 FROM transaction 
			 WHERE amount > (SELECT AVG(amount)
							 FROM transaction));

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE id NOT IN (SELECT DISTINCT company_id FROM transaction);
-- Se podría usar también (sería más óptimo) un EXISTS ()


-- NIVELL 2

-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.
SELECT substring(timestamp, 1, 10) as Date, sum(amount) as Total
FROM transaction
GROUP BY Date
order by Total desc
LIMIT 5;
-- Podria usar date(timestamp) directamente en lugar de substring()


-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT country, round(AVG(amount), 2) as MediaVentas
FROM company
JOIN transaction
ON (company.id = company_id)
GROUP BY country
ORDER BY MediaVentas desc;

-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
-- Mostra el llistat aplicant JOIN i subconsultes.
SELECT company_name, amount
FROM company
JOIN transaction
ON (company.id = company_id)
WHERE country = (SELECT country FROM company WHERE company_name = "Non Institute");

-- Mostra el llistat aplicant solament subconsultes.
SELECT company_name, amount
FROM company, transaction
WHERE company.id = company_id
AND country = (SELECT country FROM company WHERE company_name = "Non Institute");


-- NIVELL 3

-- Exercici 1
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.
SELECT company_name, phone, country, substring(timestamp, 1, 10) as Date, amount
FROM company
JOIN transaction
ON (company.id = company_id)
WHERE substring(timestamp, 1, 10) IN ("2021-04-29", "2021-07-20", "2022-03-13")
AND amount BETWEEN 100 AND 200
ORDER BY amount desc;


-- Exercici 2
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
SELECT company_name, IF(count(amount)>4, "Més de 4 transaccions", "4 o menys transaccions") as NumTrans
FROM company
JOIN transaction
ON (company.id = company_id)
GROUP BY company_name
ORDER BY NumTrans;


