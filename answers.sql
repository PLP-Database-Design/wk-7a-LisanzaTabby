-- Question 1 SQL Query to transform the ProductDetail Table into 1NF
-- Creating a Database 1
Create Database DB1;
-- Selecting Database to use
 Use DB1;
 
-- Creating a Table 1
CREATE TABLE ProductDetail (
  OrderID INT,
  CustomerName VARCHAR(50),
  Products VARCHAR(100)
);
-- Inserting Data into Table 1
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Converting to 1NF  using the Recusive CTE method (split_products)

 WITH RECURSIVE split_products AS (
  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS rest
  FROM ProductDetail

  UNION ALL

  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS Product,
    SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
  FROM split_products
  WHERE rest != ''
)
SELECT OrderID, CustomerName, Product
FROM split_products
ORDER BY OrderID;

-- Quetsion 2 Acheiving 2NF on the Order details table
Use DB1;
-- create ordetailes table
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);
-- inserting data into orderdetails
INSERT INTO OrderDetails VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Removing partial dependencies customerName by creating customer table and importing relevant data from the orderdetails table
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Customers
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- removing orders from the OrderDetails table into the Orderitems table and importing relevant data from the OrderDetails table 
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

INSERT INTO OrderItems
SELECT OrderID, Product, Quantity
FROM OrderDetails;