
/*******************************************************
Script: Lab07.sql
Author: Yash Khanduja
Date: Nov-25th, 2020
I, Yash Khanduja, student number 000826385, certify that this material is my original work. 
No other person's work has been used without due acknowledgment and I have not made my work available to anyone else.
********************************************************/

-- Setting NOCOUNT ON suppresses completion messages for each INSERT
SET NOCOUNT ON


-- Set date format to year, month, day
SET DATEFORMAT ymd;

-- Make the master database the current database
USE master

-- If database co859 exists, drop it
IF EXISTS (SELECT * FROM sysdatabases WHERE name = 'co859')
  DROP DATABASE co859;
GO

-- Create the co859 database
CREATE DATABASE co859;
GO

-- Make the co859 database the current database
USE co859;

-- Create dental_services table
CREATE TABLE Product (
  Product_id INT PRIMARY KEY, 
  Product_description VARCHAR(30), 
  Product_type CHAR(1) CHECK (Product_type IN ('B', 'S', 'V','P')), 
  quantity_on_hand MONEY,
  sales_ytd MONEY); 

-- Create sales table
CREATE TABLE sales (
	sales_id INT PRIMARY KEY, 
	sales_date DATE, 
	amount MONEY, 
	Product_id INT FOREIGN KEY REFERENCES Product(Product_id));
GO

-- Insert dental_services records
INSERT INTO Product VALUES(1001, 'Gerbera Delight', 'B', 190, 570);
INSERT INTO Product VALUES(1002, 'Sun Spray', 'S', 264, 792);
INSERT INTO Product VALUES(1003, 'Pink Notion Vase', 'V', 34, 102);
INSERT INTO Product VALUES(1004, 'Stately Croton', 'P',69, 207);
INSERT INTO Product VALUES(1005, 'Divine Orchid', 'P', 64, 192);

-- Insert sales records
INSERT INTO sales VALUES(1, '2020-9-1', 190, 1001);
INSERT INTO sales VALUES(2, '2020-9-7', 34, 1003);
INSERT INTO sales VALUES(3, '2020-9-8', 264, 1002);
INSERT INTO sales VALUES(4, '2020-9-9', 264, 1002);
INSERT INTO sales VALUES(5, '2020-9-11', 190, 1001);
INSERT INTO sales VALUES(6, '2020-9-13', 264, 1002);
INSERT INTO sales VALUES(7, '2020-9-14', 34, 1003);
INSERT INTO sales VALUES(8, '2020-9-16', 34, 1003);
INSERT INTO sales VALUES(9, '2020-9-17', 69, 1004);
INSERT INTO sales VALUES(10, '2020-9-19', 34, 1003);
INSERT INTO sales VALUES(11, '2020-9-20', 190, 1001);
INSERT INTO sales VALUES(12, '2020-9-21', 64, 1005);
INSERT INTO sales VALUES(13, '2020-9-26', 190, 1001);
INSERT INTO sales VALUES(14, '2020-9-28', 64, 1005);
INSERT INTO sales VALUES(15, '2020-9-28', 64, 1005);
GO

CREATE INDEX IX_Product
ON product (Product_description);

GO

CREATE VIEW high_end_Product
AS
SELECT Product_id, SUBSTRING(Product_description, 1, 15) as short_name , sales_ytd
FROM Product
WHERE quantity_on_hand > (SELECT avg(quantity_on_hand) from Product)

GO
-- Verify inserts
CREATE TABLE verify (
  table_name varchar(30), 
  actual INT, 
  expected INT);
GO

INSERT INTO verify VALUES('Product', (SELECT COUNT(*) FROM Product), 5);
INSERT INTO verify VALUES('sales', (SELECT COUNT(*) FROM sales), 15);
PRINT 'Verification';
SELECT table_name, actual, expected, expected - actual discrepancy FROM verify;
DROP TABLE verify;
GO

--- Insert Trigger---
CREATE TRIGGER insertProduct
ON [dbo].[sales]
AFTER INSERT 
AS
	BEGIN 
	UPDATE Product SET sales_ytd = p.sales_ytd + a.amount FROM Product as p
	INNER JOIN inserted AS a ON p.Product_id  = a.Product_id;
	END
GO

-- Update Trigger--
CREATE TRIGGER updateProduct
ON [dbo].[sales]
AFTER UPDATE
AS
	BEGIN
	UPDATE Product SET sales_ytd = p.sales_ytd + a.amount - b.amount FROM Product as p
	INNER JOIN inserted AS a ON p.Product_id = a.Product_id
	JOIN deleted AS b ON p.Product_id = b.Product_id;
	END
GO

--- Trigger for Delete ---
CREATE TRIGGER delProduct
ON[dbo].[sales]
AFTER DELETE 
AS
	BEGIN
	UPDATE Product SET sales_ytd = p.sales_ytd - b.amount FROM Product AS p
	JOIN deleted AS b ON p.Product_id = b.Product_id;
	END
GO

-- Verification
PRINT 'Verify triggers'
PRINT 'Master Table Before Changes'
SELECT * from  Product;
INSERT INTO sales VALUES(16, '2020-11-01', 34, 1003);
PRINT 'After INSERT'
SELECT * from  Product;
DELETE FROM sales WHERE sales_id=16;
PRINT 'After DELETE'
SELECT * from  Product;
UPDATE sales SET amount=30000 WHERE sales_id=15;
PRINT 'After UPDATE'
SELECT * from  Product;