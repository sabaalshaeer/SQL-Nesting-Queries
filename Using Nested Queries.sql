--Searching Based on a Single-Row Subquery Result
--List of sales representatives who have been earning a commission at rates above the avarage rate for the team

Select *
From Slspers

Select repid, fname, lname, commrate
From Slspers
Where commrate > .03

Select repid, fname, lname, commrate
From Slspers
Where commrate > 
	(Select AVG(commrate) from Slspers)


--Searching Based on a Multiple-Row Subquery Result
--Identify book titles that have not sold any copies at all
SELECT partnum, bktitle
FROM Titles
WHERE partnum NOT IN
	(SELECT partnum FROM Sales)


--Searching by comparing values from a Subquery
--List of books currently in print (from the titles table),
--as weel as a list of books no longer in print(from the Obsolete_titles table)
--compare data in the titles and obsolete_titles tables
SELECT *
FROM Obsolete_Titles
ORDER BY devcost

SELECT *
FROM Titles
ORDER BY devcost

--Insert a where clause in the second query to return only the books from titles whose 
--development cost is less than the development cost of each book contained in Obsolete_Titles
SELECT *
FROM Obsolete_Titles
ORDER BY devcost

SELECT *
FROM Titles
WHERE devcost < ALL (SELECT devcost FROM Obsolete_Titles)
ORDER BY devcost

--Searching based on the Existence of a Record
--Determine if any books in your current titles(titles table) are also in the obsolete titles (obsolete_titles)
--Explore how you might determine which books are obsolete
SELECT partnum FROM Obsolete_Titles
SELECT partnum FROM Obsolete_Titles WHERE partnum = 39213
SELECT partnum FROM Obsolete_Titles WHERE partnum = 99999

--Use the query as a inner query, so surround it with parentheses
SELECT *
FROM Titles
WHERE EXISTS
	(SELECT partnum FROM Obsolete_Titles WHERE partnum = Titles.partnum)

--verify your results by adding another query
SELECT *
FROM Titles
WHERE EXISTS
	(SELECT partnum FROM Obsolete_Titles WHERE partnum = Titles.partnum)

SELECT * FROM Obsolete_Titles

--Add another condition to the inner query's Where clause
SELECT *
FROM Titles
WHERE EXISTS
	(SELECT partnum FROM Obsolete_Titles WHERE partnum = Titles.partnum
	AND bktitle = Titles.bktitle)

SELECT * FROM Obsolete_Titles

--Show books in Titles that do not exist in Obsolete_titles
SELECT *
FROM Titles
WHERE NOT EXISTS
	(SELECT partnum FROM Obsolete_Titles WHERE partnum = Titles.partnum
	AND bktitle = Titles.bktitle)

SELECT * FROM Obsolete_Titles


--Generation Output Using Correlated Subqueries
--List the contact information of customers that have bought 500 books in a single purchase
--Determine which columns you will select from the titles and customers tables, using Cross Join query
SELECT *
FROM Titles
CROSS JOIN Customers

--Reduce the number of columns shown in the report
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers

--Determine how you might get sales quantities for a particular customer/book combination
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers

SELECT * FROM Sales

--Add Where clause to the bottom query
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers

SELECT * FROM Sales
WHERE Sales.custnum = 20181
AND Sales.partnum = 40321

--Revise the Select clause in the bottom query to output just the qty column
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers

SELECT qty FROM Sales
WHERE Sales.custnum = 20181
AND Sales.partnum = 40321


--Use the bottom query as a subquery in the main query's Where clause
--And add parentheses around the subquery
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers
WHERE 500 IN
    (SELECT qty FROM Sales
    WHERE Sales.custnum = 20181
    AND Sales.partnum = 40321)

--Pull the values in line 133 and 134
SELECT partnum, bktitle, custnum, custname, address
FROM Titles
CROSS JOIN Customers
WHERE 500 IN
    (SELECT qty FROM Sales
    WHERE Sales.custnum = Customers.custnum
    AND Sales.partnum = Titles.partnum)

--Using Apply to combine Data from two tables
--Create an OUTER APPLY query to list all salespeople and the books they have sold
SELECT *
FROM Slspers
OUTER APPLY Sales
WHERE Slspers.repid = Sales.repid

--Filtering grouped data with in Subquery
SELECT *
FROM Slspers

--Prototype a subquery that lists sales representatives who have sold at leaset 2375 books
SELECT *
FROM Slspers

SELECT repid FROM Sales
GROUP BY repid
HAVING SUM(qty) >= 2375


--Add the subquery to the main query
SELECT *
FROM Slspers
WHERE repid IN
SELECT repid FROM Sales
GROUP BY repid
HAVING SUM(qty) >= 2375

--suround the subquery with parentheses
SELECT *
FROM Slspers
WHERE repid IN
	(SELECT repid FROM Sales
	GROUP BY repid
	HAVING SUM(qty) >= 2375)

--Generating Output using nested subqueries
--Determined from the price list in the store that any book that is price above $49
SELECT *
FROM Customers

SELECT *
FROM Sales

SELECT *
FROM Titles
WHERE slprice > 49

--Nest queries using Wher clause
SELECT *
FROM Customers
where custnum In(
SELECT *
FROM Sales
where partnum In(
SELECT *
FROM Titles
WHERE slprice > 49

--Select the second and third queries to indent them one level by pressing tab
SELECT *
FROM Customers
where custnum In(
	SELECT *
	FROM Sales
	where partnum In(
	SELECT *
	FROM Titles
	WHERE slprice > 49

--Select third query and press tab 
SELECT *
FROM Customers
where custnum In(
	SELECT *
	FROM Sales
	where partnum In(
		SELECT *
		FROM Titles
		WHERE slprice > 49

--Close the parentheses at the end of the last subquery
SELECT *
FROM Customers
WHERE custnum IN (
	SELECT *
	FROM Sales
	WHERE partnum IN (
		SELECT *
		FROM Titles
		WHERE slprice > 49))

--Revise the Select clauses to extract only the columns needed for the report
SELECT custnum, custname, address, city
FROM Customers
WHERE custnum IN (
	SELECT custnum
	FROM Sales
	WHERE partnum IN (
		SELECT partnum
		FROM Titles
		WHERE slprice > 49))







