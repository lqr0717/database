CREATE DATABASE Team_6_Final;
USE Team_6_Final;
-----CREATE TABLES
CREATE TABLE Departments (
	DepartmentID INT IDENTITY NOT NULL PRIMARY KEY,
	DepartmentName varchar(40) NOT NULL,
	DepartmentDetails varchar(255) NOT NULL,
);
CREATE TABLE Managers(
 ManagerID int IDENTITY NOT NULL PRIMARY KEY ,
 FirstName varchar(40) NOT NULL,
 LastName varchar(40) NOT NULL
);
CREATE TABLE Manufactures(
ManufactureID  INT IDENTITY NOT NULL PRIMARY KEY,
ManufactureName varchar(40) NOT NULL,
PhoneNumber varchar(10) NOT NULL
);
CREATE TABLE Customers
(CustomerID INT IDENTITY NOT NULL PRIMARY KEY,
FirstName VARCHAR(40)  NOT NULL,
LastName VARCHAR(40)  NOT NULL,
PhoneNumber VARCHAR(10) NOT NULL,
Email VARCHAR(40) NOT NULL
);

CREATE TABLE Products(
ProductID INT IDENTITY NOT NULL PRIMARY KEY,
ProductName varchar(40) NOT NULL,
SellingPrice money NOT NULL,
ProductDetail varchar(255) NOT NULL,
ManufactureID INT FOREIGN KEY REFERENCES Manufactures(ManufactureID),
DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
Inventory int NOT NULL
);
CREATE TABLE Employees(
 EmployeeID int IDENTITY NOT NULL PRIMARY KEY,
 FirstName varchar(40) NOT NULL,
 LastName varchar(40) NOT NULL,
 ManagerID int NOT NULL
 REFERENCES Managers(ManagerID)
 );

CREATE TABLE Orders(
OrderID INT  IDENTITY NOT NULL PRIMARY KEY,
CustomerID INT REFERENCES Customers(CustomerID),
TotalPrice MONEY NOT NULL,
EmployeeID INT REFERENCES Employees(EmployeeID),
OrderDate DATE NOT NULL
);
CREATE TABLE Returns(
ReturnID INT IDENTITY NOT NULL PRIMARY KEY,
OrderID INT REFERENCES Orders(OrderID),
ReturnTotalPrice MONEY NOT NULL,
EmployeeID INT REFERENCES Employees(EmployeeID),
ReturnDate DATE NOT NULL
);

CREATE TABLE OrderedItems(
 OrderID int NOT NULL
 REFERENCES Orders(OrderID),
 ProductID int NOT NULL
 REFERENCES Products(ProductID),
 Quantity int NOT NULL,
 CONSTRAINT PKOrderItem PRIMARY KEY CLUSTERED
 (OrderID, ProductID)
 );


CREATE TABLE ReturnedItems (
ReturnID INT NOT NULL
REFERENCES Returns(ReturnID),
ProductID INT NOT NULL
REFERENCES Products(ProductID),
CONSTRAINT PKReturnItem PRIMARY KEY CLUSTERED
(ProductID, ReturnID),
ReturnQuantity INT NOT NULL
);

 -- Create a Trigger on OrderedItems Entity
-- When there is a change in OrderedItems table, 
-- We will update totalprice column on Orders table
CREATE TRIGGER UpdateOrderItem
	ON OrderedItems
AFTER INSERT, DELETE
AS
BEGIN
	DECLARE @OrderId INT 
	DECLARE @ProductId INT
	DECLARE @Quantity INT
	SET @Quantity = 0
	IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		SET @OrderId = (SELECT ins.OrderID FROM INSERTED ins)
		SET @ProductId = (SELECT ins.ProductID FROM INSERTED ins)
		SET @Quantity =  @Quantity - (SELECT ins.Quantity FROM INSERTED ins)
	END
	ELSE
	BEGIN
		SET @OrderId = (SELECT del.OrderID FROM DELETED del)
		SET @ProductId = (SELECT del.ProductID FROM DELETED del)
		SET @Quantity =  @Quantity + (SELECT del.Quantity FROM DELETED del)
	END
	UPDATE Orders
		SET TotalPrice = (
			SELECT ISNULL(SUM(p.SellingPrice * oi.Quantity), 0)
			FROM OrderedItems oi 
			INNER JOIN Products p
			ON p.ProductID = oi.ProductID 
			WHERE oi.OrderID = @OrderId
		)
	WHERE OrderID = @OrderId
	UPDATE Products 
		SET Inventory = Inventory + @Quantity 
	WHERE ProductID = @ProductId
END
-----Returned Trigger

CREATE TRIGGER UpdateReturnItem
ON ReturnedItems
AFTER INSERT, DELETE
AS
BEGIN
	DECLARE @ReturnID INT 
	DECLARE @ProductId INT
	DECLARE @Quantity INT
	SET @Quantity = 0
	IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
		SET @ReturnID = (SELECT ins.ReturnID FROM INSERTED ins)
		SET @ProductId = (SELECT ins.ProductID FROM INSERTED ins)
		SET @Quantity =  @Quantity + (SELECT ins.ReturnQuantity FROM INSERTED ins)
	END
	ELSE
	BEGIN
		SET @ReturnID = (SELECT del.ReturnID FROM DELETED del)
		SET @ProductId = (SELECT del.ProductID FROM DELETED del)
		SET @Quantity =  @Quantity - (SELECT del.ReturnQuantity FROM DELETED del)
	END
	UPDATE [Returns] 
		SET ReturnTotalPrice = (
			SELECT ISNULL(SUM(p.SellingPrice * ri.ReturnQuantity), 0)
			FROM ReturnedItems ri 
			INNER JOIN Products p
			ON p.ProductID = ri.ProductID 
			WHERE ri.ReturnID = @ReturnID
		)
	WHERE ReturnID = @ReturnID
	UPDATE Products 
		SET Inventory = Inventory + @Quantity 
	WHERE ProductID = @ProductId
END

-------Insert into Customers
 INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Amy', 'Liu', '12333333', '123222@gmail.com');
	
INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Bob', 'Sun', '12673423', '1267@gmail.com');
	
INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Chris', 'Sun', '1345555', '1345555@gmail.com');
	
INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Doris', 'Xiao', '13455678', '134523@gmail.com');
	
INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Elle', 'Xiao', '1345548', '5548@gmail.com');

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Fiona', 'Xiao', '1345546', '55788@gmail.com');

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Gigi', 'Liu', '1345588', '5978@gmail.com');

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Henry', 'Lei', '1345644', '638@gmail.com');

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Ivy', 'Lei', '2062137', 'Ivy520@gmail.com');

INSERT INTO Customers(FirstName, LastName, PhoneNumber, Email)
	VALUES('Lisa', 'Lei', '2068887', 'Lisa520@gmail.com');
-------Insert into Manufactures
INSERT Manufactures
VALUES('Manufacture A','2068905050');
INSERT Manufactures
VALUES('Manufacture B','2068805050');
INSERT Manufactures
VALUES('Manufacture C','2068105050');
INSERT Manufactures
VALUES('Manufacture D','4068105050');
INSERT Manufactures
VALUES('Manufacture E','2068105350');
INSERT Manufactures
VALUES('Manufacture F','2069105450');
INSERT Manufactures
VALUES('Manufacture G','2089105450');
INSERT Manufactures
VALUES('Manufacture H','2034105450');
INSERT Manufactures
VALUES('Manufacture I','2089105420');
INSERT Manufactures
VALUES('Manufacture J','4085105420');
INSERT Manufactures
VALUES('Manufacture K','4085610540');
INSERT Manufactures
VALUES('Manufacture L','4085109020');
INSERT Manufactures
VALUES('Manufacture M','4085355420');
INSERT Manufactures
VALUES('Manufacture N','4345105420');
INSERT Manufactures
VALUES('Manufacture O','4085105456');
-------Insert into Departments
INSERT into Departments (DepartmentName, DepartmentDetails)
VALUES
('DepartmentA', 'Men'),
('DepartmentB', 'Beauty products'),
('DepartmentC', 'Women‘s clothing products'),
('DepartmentD', 'Contemporary products'),
('DepartmentE', 'Shoes products'),
('DepartmentF', 'Kids products'),
('DepartmentG', 'Home products'),
('DepartmentH', 'Gifts products'),
('DepartmentI', 'Jewelry products'),
('DepartmentJ', 'Accessories products');

-------Insert into Managers
INSERT Managers
 VALUES ('Bob', 'Li');
INSERT Managers
 VALUES ('Lily', 'Liu');
INSERT Managers
 VALUES ('Ya', 'Wu');
INSERT Managers
 VALUES ('Bill', 'Qi');
INSERT Managers
 VALUES ('Simi', 'Zhang');
INSERT Managers
 VALUES ('Sam', 'Xi');
INSERT Managers
 VALUES ('Lucy', 'Si');
INSERT Managers
 VALUES ('Vivian', 'Li');
INSERT Managers
 VALUES ('Ann', 'Zhang');
INSERT Managers
 VALUES ('Siqi', 'Pi');

-------Insert into Empolyees
INSERT Employees
 VALUES ('Siva', 'yu', 1);
INSERT Employees
 VALUES ('Deni', 'Xi', 1);
INSERT Employees
 VALUES ('Kai', 'Xi', 1);
INSERT Employees
 VALUES ('Carol', 'Pu', 2);
INSERT Employees
 VALUES ('Sony', 'Xi', 2);
INSERT Employees
 VALUES ('Betty', 'Ti', 2);
INSERT Employees
 VALUES ('Edd', 'Xi', 3);
INSERT Employees
 VALUES ('Nick', 'Xiao', 3);
INSERT Employees
 VALUES ('Vanness', 'Lei', 3);
INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Jenny', 'Lei', '4');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Jemmy', 'Liang', '4');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Sally', 'Liu', '4');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Cecilia', 'Liu', '4');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('April', 'Liu', '5');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Lily', 'Li', '5');

INSERT INTO Employees(FirstName, LastName, ManagerID)
	VALUES('Scarlette', 'Zhang', '5');
INSERT Employees VALUES ('Michelle', 'Peng', 6);
INSERT Employees VALUES ('Yue', 'Ge', 6);
INSERT Employees VALUES ('Alex', 'Mu', 6);
INSERT Employees VALUES ('Julia', 'Wang', 7);
INSERT Employees VALUES ('Paul', 'Liu', 7);
INSERT Employees VALUES ('Harry', 'Yoo', 7);
INSERT Employees VALUES ('Daisy', 'Choi', 8);
INSERT Employees VALUES ('Chuck', 'Zhong', 8);
INSERT Employees VALUES ('Serena', 'Cheng', 8);

INSERT INTO Employees(FirstName, LastName, ManagerID)
 VALUES
('Alice','Wang', '9'),
('Tony','Zhang', '10'),
('WenPing', 'Wong', '9'),
('MingLan', 'Sheng', '9'),
('TingYe', 'Gu', '10'),
('Rulan', 'Sheng', '10');
-------Insert into Products
INSERT Products
 VALUES ('PurPleJeans', 88.00, 'Mens Dropped-Fit Distressed Jeans', 11, 1, 100);
INSERT Products
 VALUES ('BermudaShorts', 10.00, 'Mens Linen-Cotton Bermuda Shorts', 14, 1, 77);
INSERT Products
 VALUES ('VersaceShoes', 198.00, 'Mens Retro Logo Leather Sneakers', 7, 1, 88);
INSERT Products
 VALUES ('VersaceTee', 176.00, 'Mens Safety Pin Graphic Tee', 5, 1, 98);
INSERT Products
 VALUES ('GucciSunglasses', 199.00, 'Mens Angry Cat Rainbow Square Sunglasses', 1, 1, 76);

INSERT Products
 VALUES ('EyeLash', 76.00, 'Waterproof', 2, 2, 10);
INSERT Products
 VALUES ('Lancome EyeCream', 97.00, 'for intensive skin', 1, 2, 20);
INSERT Products
 VALUES ('Lancome SunCream', 60.00, 'Good Product', 3, 2, 30);
INSERT Products
 VALUES ('Lancome DayCream', 123.00, 'Soft', 9, 2, 15);
INSERT Products
VALUES ('Lancome NightCream', 80.00, 'Very rich for dry skin', 5, 2, 25);
INSERT Products
 VALUES ('AnaisCoat', 13.00, 'Citrouille Fitted Down Coat', 1,  3,88);
INSERT Products
 VALUES ('AnaisSweater', 770.00, 'Lofty Rib Turtleneck Sweater',  6, 3, 76);
INSERT Products
 VALUES ('PuffDress', 45.00, 'Puff-Sleeve Compact Knit Dress', 13,  3,96);
INSERT Products
 VALUES ('AnaisSkirt', 199.00, 'Adia Skirt',  15, 3, 57);
INSERT Products
 VALUES ('ConSkirt', 120.00, 'Confetti Ruffled-Trim Lace Midi Skirt',  12, 3, 70);


INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Double Take Ruched Jersey Dress', 88, 'Hand wash', 1, 4, 10);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Devon High-Rise Wide-Leg Linen Jeans', 145, 'Wash cold. Made in Mexico', 2, 4, 23);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Rag Jeans', 195, 'Button/zip fly; belt loops. Cotton/lyocell/elasterell-P/spandex.', 3, 4, 42);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Denim', 38, 'spandex.', 6, 4, 39);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Activewear', 38, 'Comtempary', 9, 4, 58);


INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('FashionWear', 288, 'Comtempary FashionWear', 3, 5, 6);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Veronica Beard', 77, 'Veronica Beard', 6, 5, 18);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Frame Beard', 10, 'Comtempary Frame', 2, 5, 90);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Comtempary SwimWear', 62, 'Comtempary SwimWear', 1, 5, 100);

INSERT INTO Products(ProductName, SellingPrice, ProductDetail, ManufactureID, DepartmentID, Inventory)
	VALUES('Comtempary VinceWear', 51, 'Comtempary VinceWear', 8, 5, 50);

INSERT Products VALUES ('Jungle Bingo Good Book',19.99, 'In this fun kids edition play bingo with a gorgeous blue bird-of-paradise, a three-banded armadillo, and even the poisonous automeris moth caterpillar. ',5,6,24);
INSERT Products VALUES ('Diamond Crush Thinking Putty Mega Tin',50.00,'Made with REAL Diamond Dust.',3,6,45);
INSERT Products VALUES ('Douglas Bunny',14.00,'Stuffed bunny with its silky coat sprinkled in rainbow colors.',8,6,132);
INSERT Products VALUES ('Douglas Rainbow Bunny',14.00,'Plush bunny in tie-dyed pastel colors.',8,6,152);
INSERT Products VALUES ('Douglas Pink Bunny',14.00,'Plush bunny in pink colors.',8,6,345);
INSERT Products VALUES ('Devlin Wall Clock',198.00,'GREY MARBLE. ONE SIZE',2,7,34);
INSERT Products VALUES ('Thalia Woodcroft Sideboard',198.00,'John-Richard Collection',1,7,15);
INSERT Products VALUES ('Guest Towel Tray',143.00,'Match',3,7,195);
INSERT Products VALUES ('Bernhardt Table',989.00,'Marquis Marble End Table',12,7,195);
INSERT Products VALUES ('Toothbrush Cup',177.00,'Match',3,7,195);
INSERT Products VALUES ('Mesita Redonda Side Table',177.00,'Jan Barboglio',6,8,1295);
INSERT Products VALUES ('Macon Console',987.00,'Worlds Away',14,8,583);
INSERT Products VALUES ('Red Medusa Paperweight',295.00,'Versace',4,8,583);
INSERT Products VALUES ('Black Medusa Paperweight',295.00,'Versace',4,8,231);
INSERT Products VALUES ('White Medusa Paperweight',295.00,'Versace',4,8,231);

INSERT Products
VALUES
('Rings', 100, '4.50 carat asscher-cut cubic zirconia center.', 11, 9, 100),
('Watches', 600, '41mm Stainless Steel Watch w/ Bracelet Strap, Blue', 5, 9, 100),
('Necklaces', 1000, 'Elisa Birthstone Crystal Necklace', 8, 9, 80),
('Bracelets', 2200, 'Panther Skinny Hinge Bracelet, Blue', 7, 9, 50),
('Brooches', 500, 'Half-Moon Crystal Brooch', 10, 9, 100),
('Sunglasses', 120, 'Square Metal Sunglasses', 1, 10, 200),
('Hats', 80, 'VLOGO Straw Fedora Hat', 13, 10, 55),
('Gloves', 55, 'Fingerless Fur Mittens', 8, 10, 80),
('Wraps', 55, 'Fingerless Fur Mittens', 12, 10, 80),
('Belts', 278, 'Lightweight Cashmere Scarf', 14, 10, 80);

-----------Table-Level CHECK Constraints based on a function
CREATE FUNCTION CheckInsert(@ReturnID int, @ProductID int)
RETURNS int 
AS BEGIN
 DECLARE @Count int = 0;
 SELECT @Count = ISNULL(SUM(Quantity),0)
 FROM OrderedItems oi 
 WHERE OrderID =(SELECT OrderID FROM Returns WHERE ReturnID = @ReturnID) AND ProductID = @ProductID
 RETURN @Count;
END

ALTER TABLE ReturnedItems ADD CONSTRAINT Ban CHECK (dbo.CheckInsert(ReturnID, ProductID) >= ReturnQuantity);
-----------Computed Columns based on a function
CREATE FUNCTION CalculateTotalPrice(@Quantity INT, @ProductID INT)
RETURNS MONEY
AS
 BEGIN 
  DECLARE @total MONEY;
  SELECT @total = (ISNULL(p.SellingPrice , 0) * @Quantity ) FROM Products p 
  WHERE p.ProductID = @ProductID 
  RETURN @total ;
 END


ALTER TABLE OrderedItems ADD ItemtotalPrice AS(dbo.CalculateTotalPrice(Quantity, ProductID));
ALTER TABLE ReturnedItems ADD ItemtotalPrice AS(dbo.CalculateTotalPrice(ReturnQuantity, ProductID));
-------Insert into Orders
INSERT Orders
 VALUES (1, 0, 8, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 11, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 25, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 23, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 21, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 1, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 18, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 2, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 26, '2020-01-03');
INSERT Orders
 VALUES (1, 0, 30, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 8, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 7, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 1, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 4, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 15, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 16, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 17, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 17, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 6, '2020-01-03');
INSERT Orders
 VALUES (2, 0, 5, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 28, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 27, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 19, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 11, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 17, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 16, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 10, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 14, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 12, '2020-01-03');
INSERT Orders
 VALUES (3, 0, 17, '2020-01-03');
INSERT Orders VALUES (4,0,1,'2019-06-15');
INSERT Orders VALUES (4,0,2,'2019-02-15');
INSERT Orders VALUES (4,0,4,'2019-03-30');
INSERT Orders VALUES (4,0,3,'2019-11-24');
INSERT Orders VALUES (4,0,5,'2019-06-15');
INSERT Orders VALUES (4,0,21,'2020-01-21');
INSERT Orders VALUES (4,0,22,'2020-03-23');
INSERT Orders VALUES (4,0,24,'2020-01-25');
INSERT Orders VALUES (4,0,23,'2019-03-07');
INSERT Orders VALUES (4,0,25,'2020-02-22');
INSERT Orders VALUES (5,0,11,'2019-08-23');
INSERT Orders VALUES (5,0,12,'2020-02-25');
INSERT Orders VALUES (5,0,14,'2020-01-30');
INSERT Orders VALUES (5,0,13,'2019-12-24');
INSERT Orders VALUES (5,0,15,'2019-01-15');
INSERT Orders VALUES (5,0,20,'2020-01-21');
INSERT Orders VALUES (5,0,19,'2019-03-23');
INSERT Orders VALUES (5,0,18,'2020-03-25');
INSERT Orders VALUES (5,0,17,'2019-06-07');
INSERT Orders VALUES (5,0,16,'2019-09-22');
INSERT Orders VALUES (6,0,30,'2020-02-21');
INSERT Orders VALUES (6,0,29,'2019-12-23');
INSERT Orders VALUES (6,0,28,'2020-03-25');
INSERT Orders VALUES (6,0,27,'2019-10-07');
INSERT Orders VALUES (6,0,26,'2019-08-22');
INSERT Orders VALUES (6,0,6,'2020-01-21');
INSERT Orders VALUES (6,0,9,'2019-10-23');
INSERT Orders VALUES (6,0,8,'2010-09-25');
INSERT Orders VALUES (6,0,7,'2019-04-07');
INSERT Orders VALUES (6,0,10,'2019-07-22');
INSERT Orders
 VALUES (7, 0, 8, '2020-03-11');
INSERT Orders
 VALUES (7, 0, 7, '2020-01-13');
INSERT Orders
 VALUES (7, 0, 29, '2020-02-22');
INSERT Orders
 VALUES (7, 0, 21, '2020-07-03');
INSERT Orders
 VALUES (7, 0, 17, '2020-09-17');
INSERT Orders
 VALUES (7, 0, 16, '2020-02-15');
INSERT Orders
 VALUES (7, 0, 20, '2020-01-9');
INSERT Orders
 VALUES (7, 0, 21, '2020-03-23');
INSERT Orders
 VALUES (7, 0, 21, '2020-01-23');
INSERT Orders
 VALUES (7, 0, 7, '2020-01-09');



INSERT Orders
VALUES
(8, 0, 1, '2020-02-05'),
(8, 0, 12, '2019-02-25'),
(8, 0, 2, '2019-07-01'),
(8, 0, 14, '2020-02-21'),
(8, 0, 25, '2020-02-20'),
(8, 0, 12, '2020-02-05'),
(8, 0, 10, '2020-02-25'),
(8, 0, 3, '2019-07-01'),
(8, 0, 11, '2020-01-21'),
(8, 0, 24, '2020-02-21'),
(9, 0, 20, '2019-09-09'),
(9, 0, 21, '2019-01-09'),
(9, 0, 15, '2019-11-09'),
(9, 0, 8, '2019-10-09'),
(9, 0, 11, '2019-10-10'),
(9, 0, 20, '2019-07-09'),
(9, 0, 21, '2019-03-09'),
(9, 0, 15, '2019-10-09'),
(9, 0, 8, '2019-10-09'),
(9, 0, 11, '2019-10-10'),
(10, 0, 3,'2020-09-20'),
(10, 0, 12,'2020-01-22'),
(10, 0, 10,'2020-02-18'),
(10, 0, 11,'2020-03-01'),
(10, 0, 3,'2020-09-19'),
(10, 0, 13,'2020-02-22'),
(10, 0, 10,'2020-02-19'),
(10, 0, 7,'2020-03-01'),
(10, 0, 14,'2020-03-02'),
(10, 0, 12,'2020-02-02');




-------Insert into OrdersItems Table
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (1, 2, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (1, 4, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (1, 6, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (2, 1, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (2, 3, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (2, 5, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (3, 1, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (3, 16, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (3, 10, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (4, 1, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (4, 12, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (4, 18, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (5, 5, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (5, 7, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (5, 10, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (6, 4, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (6, 7, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (6, 8, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (7, 2, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (7, 18, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (7, 14, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (8, 1, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (8, 10, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (8, 20, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (9, 5, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (9, 2, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (9, 6, 7);
INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (10, 17, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (10, 30, 7);
 INSERT OrderedItems(OrderID, ProductID, Quantity)
 VALUES (10, 10, 7);


-- Insert Into Returns Table

INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('1', '0', '1', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('2', '0', '1', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('3', '0', '7', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('4', '0', '8', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('5', '0', '1', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('6', '0', '2', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('7', '0', '6', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('8', '0', '9', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('9', '0', '1', GETDATE());
INSERT INTO Returns (OrderID, ReturnTotalPrice, EmployeeID, ReturnDate)
	VALUES('10', '0', '1', GETDATE());


---- Insert into ReturnItems Table

INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(6, 4, 7);
INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(7, 2, 7);
INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(7, 14, 7);
INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(8, 1, 7);
INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(8, 10, 7);
INSERT INTO ReturnedItems (ReturnID, ProductID, ReturnQuantity)
	VALUES(9, 5, 7);
INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(1,2,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(1,4,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(2,1,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(2,5,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(3,10,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(3,16,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(4,12,5);
 INSERT ReturnedItems( ReturnID, ProductID,ReturnQuantity )
 VALUES(5,5,5);



-------------VIEW
CREATE VIEW TopProductsEachDepartments AS
WITH TMP AS (
SELECT
 DepartmentID,
 DepartmentName,
 ProductID,
 ItemtotalPrice
FROM 
(SELECT RANK() OVER (PARTITION BY p.DepartmentID ORDER BY SUM(oi.ItemtotalPrice) DESC) AS ranking,
p.DepartmentID, 
dp.DepartmentName, 
oi.ProductID, 
SUM(oi.ItemtotalPrice) AS ItemtotalPrice
FROM Products AS P
INNER JOIN Departments AS dp
ON dp.DepartmentID = p.DepartmentID 
INNER JOIN OrderedItems AS oi
ON oi.ProductID = p.ProductID 
GROUP BY p.DepartmentID, dp.DepartmentName, oi.ProductID) AS d
WHERE d.ranking <= 3
)
SELECT
 DISTINCT B.DepartmentID,
 B.DepartmentName,
 STUFF((SELECT ', ' + RTRIM(cast(A.ProductID as char)) 
   FROM TMP A
   WHERE A.DepartmentID = B.DepartmentID
   ORDER BY A.ItemtotalPrice
   FOR XML PATH('')), 1, 2, '') AS TopSellingProducts
FROM TMP B;

CREATE VIEW TopProductsQuantityEachDepartments AS
WITH TMP AS (
SELECT
 DepartmentID,
 DepartmentName,
 ProductID,
 ItemtotalCount
FROM 
(SELECT RANK() OVER (PARTITION BY p.DepartmentID ORDER BY SUM(oi.Quantity) DESC) AS ranking,
p.DepartmentID, 
dp.DepartmentName, 
oi.ProductID, 
SUM(oi.Quantity) AS ItemtotalCount
FROM Products AS P
INNER JOIN Departments AS dp
ON dp.DepartmentID = p.DepartmentID 
INNER JOIN OrderedItems AS oi
ON oi.ProductID = p.ProductID 
GROUP BY p.DepartmentID, dp.DepartmentName, oi.ProductID) AS d
WHERE d.ranking < =3
)
SELECT
 DISTINCT B.DepartmentID,
 B.DepartmentName,
 STUFF((SELECT ', ' + RTRIM(cast(A.ProductID as char)) 
   FROM TMP A
   WHERE A.DepartmentID = B.DepartmentID
   ORDER BY A.ItemtotalCount
   FOR XML PATH('')), 1, 2, '') AS TopProductsCount
FROM TMP B;
