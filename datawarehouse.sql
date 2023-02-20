CREATE DATABASE hotel_data_warehouse;

USE DATABASE hotel_data_warehouse;

CREATE TABLE Fact_Reservation (
ReservationID INT PRIMARY KEY,
CustomerID INT NOT NULL,
RoomID INT NOT NULL,
CheckInDate DATE NOT NULL,
CheckOutDate DATE NOT NULL,
Price DECIMAL(10,2) NOT NULL,
PaymentID INT NOT NULL,
FeedbackID INT NOT NULL
);

CREATE TABLE Dim_Customer (
CustomerID INT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Address VARCHAR(100) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Email VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Room (
RoomID INT PRIMARY KEY,
RoomNumber INT NOT NULL,
RoomType VARCHAR(50) NOT NULL,
RoomRate DECIMAL(10,2) NOT NULL
);

CREATE TABLE Dim_Staff (
StaffID INT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Position VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Email VARCHAR(50) NOT NULL
);

CREATE TABLE Dim_Payment (
PaymentID INT PRIMARY KEY,
ReservationID INT NOT NULL,
PaymentAmount DECIMAL(10,2) NOT NULL,
PaymentMethod VARCHAR(50) NOT NULL,
PaymentDate DATE NOT NULL
);

CREATE TABLE Dim_Feedback (
FeedbackID INT PRIMARY KEY,
ReservationID INT NOT NULL,
CustomerID INT NOT NULL,
Comments VARCHAR(1000) NOT NULL,
Ratings INT NOT NULL,
Suggestions VARCHAR(1000) NOT NULL,
FeedbackDate DATE NOT NULL
);

CREATE TABLE Dim_ServiceRequests (
ServiceRequestID INT PRIMARY KEY,
RequestDate DATE NOT NULL,
ServiceType VARCHAR(50) NOT NULL,
ServiceCost DECIMAL(10,2) NOT NULL,
CustomerID INT NOT NULL
);

-- Load the Dim_Customer table
INSERT INTO Dim_Customer
SELECT *
FROM Customer;

-- Load the Dim_Room table
INSERT INTO Dim_Room
SELECT *
FROM Room;

-- Load the Dim_Staff table
INSERT INTO Dim_Staff
SELECT *
FROM Staff;

-- Load the Dim_Payment table
INSERT INTO Dim_Payment
SELECT *
FROM Payment;

-- Load the Dim_Feedback table
INSERT INTO Dim_Feedback
SELECT *
FROM Feedback;

-- Load the Dim_ServiceRequests table
INSERT INTO Dim_ServiceRequests
SELECT *
FROM ServiceRequests;

--Load the Fact Reservation
INSERT INTO Fact_Reservation (ReservationID, CustomerID, RoomID, CheckInDate, CheckOutDate, Price, PaymentID, FeedbackID)
SELECT R.ReservationID, R.CustomerID, R.RoomID, R.CheckInDate, R.CheckOutDate, R.Price, R.PaymentID, R.FeedbackID
FROM Reservation R;


--Load data into the Customer dimension table:

INSERT INTO Customer (CustomerID, Name, Address, PhoneNumber, Email)
SELECT DISTINCT c.CustomerID, c.Name, c.Address, c.PhoneNumber, c.Email
FROM Reservation r
JOIN Customer c ON r.CustomerID = c.CustomerID;

--Load data into the Room dimension table:

INSERT INTO Room (RoomID, RoomNumber, RoomType, RoomRate)
SELECT DISTINCT r.RoomID, r.RoomNumber, r.RoomType, r.RoomRate
FROM Reservation r;

--Load data into the Staff dimension table:
INSERT INTO Staff (StaffID, Name, Position, PhoneNumber, Email)
SELECT DISTINCT s.StaffID, s.Name, s.Position, s.PhoneNumber, s.Email
FROM Shift sh
JOIN Staff s ON sh.StaffID = s.StaffID;

--Load data into the Payment dimension table:
INSERT INTO Payment (PaymentID, ReservationID, PaymentAmount, PaymentMethod, PaymentDate)
SELECT DISTINCT p.PaymentID, p.ReservationID, p.PaymentAmount, p.PaymentMethod, p.PaymentDate
FROM Reservation r
JOIN Payment p ON r.PaymentID = p.PaymentID;

--Load data into the Feedback dimension table:
INSERT INTO Feedback (FeedbackID, ReservationID, CustomerID, Comments, Ratings, Suggestions, FeedbackDate)
SELECT DISTINCT f.FeedbackID, f.ReservationID, f.CustomerID, f.Comments, f.Ratings, f.Suggestions, f.FeedbackDate
FROM Reservation r
JOIN Feedback f ON r.FeedbackID = f.FeedbackID;

--Load data into the ServiceRequests dimension table:
INSERT INTO ServiceRequests (ServiceRequestID, RequestDate, ServiceType, ServiceCost, CustomerID)
SELECT DISTINCT sr.ServiceRequestID, sr.RequestDate, sr.ServiceType, sr.ServiceCost, sr.CustomerID
FROM ServiceRequests sr;

--Load data into the Reservation fact table:
INSERT INTO Reservation (ReservationID, CustomerID, RoomID, CheckInDate, CheckOutDate, Price, PaymentID, FeedbackID)
SELECT DISTINCT r.ReservationID, r.CustomerID, r.RoomID, r.CheckInDate, r.CheckOutDate, r.Price, r.PaymentID, r.FeedbackID
FROM Reservation r;

-- SELECT statements for data analysis:

-- Get the total revenue by room type for a specific time period:
SELECT Room.RoomType, SUM(Reservation.Price) as TotalRevenue
FROM Reservation
JOIN Room ON Reservation.RoomID = Room.RoomID
WHERE Reservation.CheckInDate >= '2022-01-01' AND Reservation.CheckOutDate <= '2022-03-31'
GROUP BY Room.RoomType;

--Get the top 10 customers with the highest total spending:
SELECT Customer.Name, SUM(Reservation.Price) as TotalSpending
FROM Reservation
JOIN Customer ON Reservation.CustomerID = Customer.CustomerID
GROUP BY Customer.Name
ORDER BY TotalSpending DESC
LIMIT 10;

--Get the average ratings and comments for each room type:
SELECT Room.RoomType, AVG(Feedback.Ratings) as AvgRatings, AVG(Feedback.Comments) as AvgComments
FROM Reservation
JOIN Room ON Reservation.RoomID = Room.RoomID
JOIN Feedback ON Reservation.FeedbackID = Feedback.FeedbackID
GROUP BY Room.RoomType;
