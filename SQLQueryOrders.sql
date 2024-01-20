create database capstone;
use capstone;
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');
  CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);
select * from customers;
select name,email from customers where name like 'j%';
  select * from Orders;
    select sum(quantity) AS Total_Quantity from orders;
    SELECT * FROM products WHERE price > 10.00;
      SELECT AVG(price) AS average_price FROM products;
      SELECT c.name AS customer_name, o.orderdate
FROM customers c
JOIN orders o ON c.customerid = o.customerid
WHERE o.orderdate >= '2023-07-05';
SELECT AVG(Price) AS AveragePrice
FROM Products;

SELECT
  Customers.CustomerID,
  Customers.Name AS CustomerName,
  COALESCE(SUM(Orders.Quantity), 0) AS TotalQuantity
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.Name;
SELECT *
FROM products
WHERE productid NOT IN (SELECT DISTINCT productid FROM Orders);

--TASK 2---


SELECT
  Customers.CustomerID,
  Customers.Name AS CustomerName,
  COALESCE(SUM(Orders.Quantity), 0) AS TotalQuantity
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.Name
ORDER BY TotalQuantity DESC
LIMIT 5;

SELECT
  productName,
  AVG(Price) AS AveragePrice
FROM Products
GROUP BY productName;
SELECT Customers.CustomerID, Customers.Name, Customers.Email
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;
SELECT
  Orders.OrderID,
  Orders.ProductName,
  Orders.Quantity
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Name LIKE 'M%';
SELECT
  SUM(Orders.Quantity * Products.Price) AS TotalRevenue
FROM Orders
JOIN Products ON Orders.ProductName = Products.ProductName;
SELECT
  C.CustomerID,
  C.Name AS CustomerName,
  COALESCE(SUM(O.Quantity * P.Price), 0) AS TotalRevenue
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN Products P ON O.ProductName = P.ProductName
GROUP BY C.CustomerID, C.Name;
SELECT
  C.CustomerID,
  C.Name AS CustomerName
FROM Customers C
WHERE NOT EXISTS (
  SELECT P.ProductName
  FROM Products P
  WHERE NOT EXISTS (
    SELECT O.OrderID
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID AND O.ProductName = P.ProductName
  )
);
SELECT
    (COUNT(CASE WHEN Quantity > AvgQuantity THEN 1 END) * 100.0 / COUNT(*)) AS PercentageGreaterThanAverage
FROM
    Orders
CROSS JOIN
    (SELECT AVG(Quantity) AS AvgQuantity FROM Orders) AS AvgQ;


    --TASK3---


SELECT c.customerID, c.name
FROM customers c
WHERE NOT EXISTS (
    SELECT p.productID
    FROM products p
    WHERE NOT EXISTS (
        SELECT o.orderID
        FROM orders o
        WHERE c.customerID= o.customerID
        AND p.productID = o.ProductName
    )
);
SELECT DISTINCT
    p.ProductID,
    p.ProductName
FROM
    Products p
WHERE
    NOT EXISTS (
        SELECT c.CustomerID
        FROM Customers c
        WHERE NOT EXISTS (
            SELECT 1
            FROM Orders o
            WHERE o.ProductName = p.ProductName AND o.CustomerID = c.CustomerID
        )
    );
SELECT
    FORMAT(OrderDate, 'MMMM yyyy') AS MonthYear,
    SUM(Quantity * Price) AS TotalRevenue
FROM
    Orders o
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY
    FORMAT(OrderDate, 'MMMM yyyy')
ORDER BY
    MIN(OrderDate);



SELECT
    p.ProductID,
    p.ProductName,
    COUNT(DISTINCT o.CustomerID) AS NumberOfCustomers,
    COUNT(DISTINCT o.CustomerID) * 1.0 / (SELECT COUNT(*) FROM Customers) AS CustomerPercentage
FROM
    Products p
JOIN Orders o ON p.ProductName = o.ProductName
GROUP BY
    p.ProductID, p.ProductName
HAVING
    COUNT(DISTINCT o.CustomerID) * 1.0 / (SELECT COUNT(*) FROM Customers) > 0.5;

SELECT
    c.CustomerID,
    c.Name,
    c.Email,
    SUM(o.Quantity * p.Price) AS TotalSpent
FROM
    Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Products p ON o.ProductName = p.ProductName
GROUP BY
    c.CustomerID, c.Name, c.Email
ORDER BY
    TotalSpent DESC
LIMIT 5;
SELECT
    o.CustomerID,
    c.Name AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.Quantity,
    SUM(o.Quantity) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS RunningTotal
FROM
    Orders o
JOIN
    Customers c ON o.CustomerID = c.CustomerID
ORDER BY
    o.CustomerID, o.OrderDate;

WITH Orders AS (
    SELECT
        OrderID,
        CustomerID,
        ProductName,
        OrderDate,
        Quantity,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum
    FROM
        Orders
)
SELECT
    o.OrderID,
    c.CustomerID,
    c.Name AS CustomerName,
    p.ProductName,
    o.OrderDate,
    o.Quantity
FROM
    Orders 
JOIN
    Customers c ON c.CustomerID = c.CustomerID
WHERE
    r.RowNum <= 3
ORDER BY
    c.CustomerID, o.OrderDate DESC;
WITH RankedOrders AS (
    SELECT
        OrderID,
        CustomerID,
        ProductName,
        OrderDate,
        Quantity,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum
    FROM
        Orders
)
SELECT
    r.OrderID,
    c.CustomerID,
    c.Name AS CustomerName,
    r.ProductName,
    r.OrderDate,
    r.Quantity
FROM
    RankedOrders r
JOIN
    Customers c ON r.CustomerID = c.CustomerID
WHERE
    r.RowNum <= 3
ORDER BY
    c.CustomerID, r.OrderDate DESC;
WITH CustomerProductCategories AS (
    SELECT
        c.CustomerID,
        o.ProductName,
        COUNT(DISTINCT p.ProductName) AS CategoryCount
    FROM
        Customers c
    JOIN
        Orders o ON c.CustomerID = o.CustomerID
    JOIN
        Products p ON o.ProductName = p.ProductName
    GROUP BY
        c.CustomerID, o.ProductName
    HAVING
        COUNT(DISTINCT p.ProductName) >= 2
)

SELECT DISTINCT
    c.CustomerID,
    c.Name AS CustomerName,
    c.Email
FROM
    CustomerProductCategories cpc
JOIN
    Customers c ON cpc.CustomerID = c.CustomerID;
SELECT
    c.CustomerID,
    c.Name AS CustomerName,
    AVG(p.Price * o.Quantity) AS AvgRevenuePerOrder
FROM
    Customers c
JOIN
    Orders o ON c.CustomerID = o.CustomerID
JOIN
    Products p ON o.ProductName = p.ProductName
GROUP BY
    c.CustomerID, c.Name;

WITH CustomerOrderMonths AS (
    SELECT
        c.CustomerID,
        c.Name AS CustomerName,
        EXTRACT(MONTH FROM o.OrderDate) AS OrderMonth
    FROM
        Customers c
    JOIN
        Orders o ON c.CustomerID = o.CustomerID
    WHERE
        EXTRACT(YEAR FROM o.OrderDate) = 2023
    GROUP BY
        c.CustomerID, c.Name, EXTRACT(MONTH FROM o.OrderDate)
)
, UniqueMonths AS (
    SELECT DISTINCT OrderMonth
    FROM CustomerOrderMonths
)
SELECT
    com.CustomerID,
    com.CustomerName
FROM
    CustomerOrderMonths com
JOIN
    UniqueMonths um ON com.OrderMonth = um.OrderMonth
GROUP BY
    com.CustomerID, com.CustomerName
HAVING
    COUNT(DISTINCT com.OrderMonth) = (SELECT COUNT(DISTINCT OrderMonth) FROM UniqueMonths);

WITH ConsecutiveMonths AS (
    SELECT
        c.CustomerID,
        c.Name AS CustomerName,
        o.ProductName,
        o.OrderDate,
        LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID, o.ProductName ORDER BY o.OrderDate) AS PreviousOrderDate
    FROM
        Customers c
    JOIN
        Orders o ON c.CustomerID = o.CustomerID
    WHERE
        o.ProductName = 'Product A'
)
SELECT DISTINCT
    CustomerID,
    CustomerName
FROM
    ConsecutiveMonths
WHERE
    PreviousOrderDate IS NOT NULL
    AND EXTRACT(MONTH FROM OrderDate) = EXTRACT(MONTH FROM PreviousOrderDate) + 1
    AND EXTRACT(YEAR FROM OrderDate) = EXTRACT(YEAR FROM PreviousOrderDate);

SELECT DISTINCT
    o.ProductName,
    p.Price
FROM
    Orders o
JOIN
    Products p ON o.ProductName = p.ProductName
WHERE
    o.CustomerID = 1
GROUP BY
    o.ProductName, p.Price
HAVING
    COUNT(o.OrderID) >= 2;


	                                       -------This project has done in MySQL-------




