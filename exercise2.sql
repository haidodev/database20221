CREATE TABLE Company (
  CompanyID int GENERATED ALWAYS AS IDENTITY,
  Name varchar(40),
  NumberofEmployee int,
  Address varchar(50),
  Telephone char(15),
  EstablishmentDay date,
  PRIMARY KEY (CompanyID)
);


CREATE TABLE Product (
  ProductID int GENERATED ALWAYS AS IDENTITY,
  Name varchar(40),
  Color char(14),
  Price decimal(10,2),
  PRIMARY KEY (ProductID)
);



CREATE TABLE Supply (
  CompanyID int,
  ProductID int,
  Quantity int,
  PRIMARY KEY(CompanyID,ProductID),
  FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

--1
SELECT *
FROM Company
WHERE Address LIKE 'London';

--2
SELECT Name, Color, Price
FROM Product
WHERE Color = 'black'
  AND Price > 5000;

--3
SELECT Company.Name, Company.Telephone
FROM Company 
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  LEFT JOIN Product ON Product.ProductID = Supply.ProductID
WHERE Product.Color = 'red';

--4
SELECT Company.Name, Company.Telephone
FROM Company 
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  LEFT JOIN Product ON Product.ProductID = Supply.ProductID
WHERE Product.Color = 'black'
INTERSECT 
SELECT Company.Name, Company.Telephone
FROM Company 
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  LEFT JOIN Product ON Product.ProductID = Supply.ProductID
WHERE Product.Color = 'blue';

--5
SELECT Name
FROM Product
WHERE Price >= ALL(SELECT Price FROM Product);

--6
SELECT Company.Name, Company.Telephone
FROM Company 
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  LEFT JOIN Product ON Product.ProductID = Supply.ProductID
GROUP BY Company.CompanyID
HAVING COUNT(*) >= 2;

--7
SELECT Company.CompanyID, Company.Name
FROM Company
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  LEFT JOIN Product ON Product.ProductID = Supply.ProductID
WHERE Product.Color = 'yellow'
GROUP BY Company.CompanyID
HAVING COUNT(*) = (
  SELECT COUNT(*)
  FROM Product
  WHERE Color = 'yellow');

--8
SELECT Company.CompanyID, Name, SUM(Quantity)
  FROM Company
    LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
  GROUP BY Company.CompanyID
ORDER BY 3 DESC NULLS LAST
LIMIT 1;

--9
SELECT Company.CompanyID, Company.Name. AVG(Quantity)
FROM Company
  LEFT JOIN Supply ON Company.CompanyID = Supply.CompanyID
GROUP BY Company.CompanyID
ORDER BY 3;

--10
SELECT *
INTO ProductClone
FROM Product;

--11
UPDATE Company
SET Address = 'Hanoi, Vietnam'
WHERE CompanyID = 1;

--12
DELETE FROM Supply
WHERE Company = 14;
DELETE FROM Company
WHERE Company = 14;

--ONLY PRODUCE BROWN
SELECT DISTINCT Company.Name
FROM Company
  JOIN Supply ON Company.CompanyID = Supply.CompanyID
  JOIN Product ON Product.ProductID = Supply.ProductID
WHERE Product.Color = 'brown'
EXCEPT
SELECT DISTINCT Company.Name
FROM Company
  JOIN Supply ON Company.CompanyID = Supply.CompanyID
  JOIN Product ON Product.ProductID = Supply.ProductID
WHERE NOT Product.Color = 'brown';

--MOST PRODUCT
SELECT Company.Name
FROM Company
  JOIN Supply ON Company.CompanyID = Supply.CompanyID
  JOIN Product ON Product.ProductID = Supply.ProductID
GROUP BY Company.CompanyID
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT Company.Name
FROM Company
  JOIN Supply ON Company.CompanyID = Supply.CompanyID
  JOIN Product ON Product.ProductID = Supply.ProductID
GROUP BY Company.CompanyID
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
FROM Supply
GROUP BY CompanyID);
--MOST QUANTITY
SELECT Company.Name
FROM Company
  JOIN Supply ON Company.CompanyID = Supply.CompanyID
  JOIN Product ON Product.ProductID = Supply.ProductID
GROUP BY Company.CompanyID
ORDER BY SUM(quantity) DESC
LIMIT 1;

--1
SELECT qq
FROM sinhvien
GROUP BY qq
HAVING COUNT(*) >= 5
WHERE gt = 'female'
  AND diem > 8;

--2
SELECT masv, tensv
FROM sinhvien
WHERE gt = 'female'
  AND diem > 8
  AND QQ IN (
    SELECT QQ
    FROM sinhvien
    GROUP BY qq
    HAVING COUNT(*) >= 10
    WHERE diem > 8
    INTERSECT
    SELECT QQ
    FROM sinhvien
    GROUP BY qq
    HAVING COUNT(*) >= 2
    WHERE gt = 'female' 
      AND diem > 8
);