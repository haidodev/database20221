--self join, choose 2 companies located in the same address
SELECT 
    A.Name, 
    B.Name
FROM 
    Company A, 
    Company B
WHERE 
    A.CompanyID <> B.CompanyID
AND 
    A.Address = B.Address;

SELECT 
    A.Name, 
    B.Name
FROM 
    Company A, 
    Company B
WHERE 
    A.CompanyID < B.CompanyID
AND 
    A.Address = B.Address;

--union opertor, choose all company produce productid 1 or 2
SELECT CompanyID FROM Supply
WHERE ProductID = 1
UNION
SELECT CompanyID FROM Supply
WHERE ProductID = 2;

SELECT DISTINCT
    CompanyID 
FROM 
    Supply
WHERE 
    ProductID = 1
    OR ProductID = 2;

--intersection operator, choose all company produce productid 1 and 2

SELECT CompanyID FROM Supply
WHERE ProductID = 1
UNION
SELECT CompanyID FROM Supply
WHERE ProductID = 2;

SELECT CompanyID FROM Supply
WHERE ProductID = 1
AND 
    CompanyID IN (
        SELECT CompanyID FROM Supply
        WHERE ProductID = 2
    )


--except operator, choose all company produce no product

SELECT CompanyID 
FROM Company
EXCEPT
SELECT CompanyID
FROM Supply


--exists operator
SELECT Company.Name
FROM Company
WHERE EXISTS(
    SELECT ProductID 
    FROM Supply
    WHERE Company.CompanyID = Supply.CompanyID);
    
-- all, any
SELECT *
FROM Product
WHERE Price > ALL(SELECT Price FROM Product);
    --all used to compare value between two tables ?