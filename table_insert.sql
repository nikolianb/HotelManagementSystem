CREATE database hotelsystem;
Use hotelsystem;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(50) NOT NULL
);

CREATE TABLE Reservation (
    ReservationID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PaymentID INT NOT NULL,
    FeedbackID INT NOT NULL
);

CREATE TABLE Room (
    RoomID INT PRIMARY KEY,
    RoomNumber INT NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    RoomRate DECIMAL(10,2) NOT NULL
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(50) NOT NULL
);

CREATE TABLE ServiceRequests (
    ServiceRequestID INT PRIMARY KEY,
    RequestDate DATE NOT NULL,
    ServiceType VARCHAR(50) NOT NULL,
    ServiceCost DECIMAL(10,2) NOT NULL,
    CustomerID INT NOT NULL
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    ReservationID INT NOT NULL,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDate DATE NOT NULL
);

CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    ReservationID INT NOT NULL,
    CustomerID INT NOT NULL,
    Comments VARCHAR(1000) NOT NULL,
    Ratings INT NOT NULL,
    Suggestions VARCHAR(1000) NOT NULL,
    FeedbackDate DATE NOT NULL
);

CREATE TABLE Shift (
    ShiftID INT PRIMARY KEY,
    StaffID INT NOT NULL,
    ShiftDate DATE NOT NULL
);
ALTER TABLE Reservation
ADD CONSTRAINT FK_Customer_Reservation
FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

ALTER TABLE Reservation
ADD CONSTRAINT FK_Room_Reservation
FOREIGN KEY (RoomID)
REFERENCES Room(RoomID);

ALTER TABLE Reservation
ADD CONSTRAINT FK_Payment_Reservation
FOREIGN KEY (PaymentID)
REFERENCES Payment(PaymentID);

ALTER TABLE Reservation
ADD CONSTRAINT FK_Feedback_Reservation
FOREIGN KEY (FeedbackID)
REFERENCES Feedback(FeedbackID);

ALTER TABLE ServiceRequests
ADD CONSTRAINT FK_Customer_ServiceRequests
FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

ALTER TABLE Payment
ADD CONSTRAINT FK_Reservation_Payment
FOREIGN KEY (ReservationID)
REFERENCES Reservation(ReservationID);

ALTER TABLE Feedback
ADD CONSTRAINT FK_Reservation_Feedback
FOREIGN KEY (ReservationID)
REFERENCES Reservation(ReservationID);

ALTER TABLE Feedback
ADD CONSTRAINT FK_Customer_Feedback
FOREIGN KEY (CustomerID)
REFERENCES Customer(CustomerID);

ALTER TABLE Shift
ADD CONSTRAINT FK_Staff_Shift
FOREIGN KEY (StaffID)
REFERENCES Staff(StaffID);

-- Populating Customer table
INSERT INTO Customer (CustomerID, Name, Address, PhoneNumber, Email)
VALUES (1, 'John Doe', '123 Main St, Anytown, USA', '+1-555-555-1234', 'johndoe@email.com'),
       (2, 'Jane Smith', '456 Park Ave, Anytown, USA', '+1-555-555-5678', 'janesmith@email.com'),
       (3, 'Bob Johnson', '789 Elm St, Anytown, USA', '+1-555-555-9012', 'bobjohnson@email.com');

-- Populating Room table
INSERT INTO Room (RoomID, RoomNumber, RoomType, RoomRate)
VALUES (1, 101, 'Standard', 100.00),
       (2, 102, 'Standard', 100.00),
       (3, 201, 'Deluxe', 150.00),
       (4, 202, 'Deluxe', 150.00),
       (5, 301, 'Suite', 200.00),
       (6, 302, 'Suite', 200.00);

-- Populating Staff table
INSERT INTO Staff (StaffID, Name, Position, PhoneNumber, Email)
VALUES (1, 'Sarah Johnson', 'Manager', '+1-555-555-1111', 'sarahjohnson@email.com'),
       (2, 'Bob Smith', 'Receptionist', '+1-555-555-2222', 'bobsmith@email.com');

-- Populating ServiceRequests table
INSERT INTO ServiceRequests (ServiceRequestID, RequestDate, ServiceType, ServiceCost, CustomerID)
VALUES (1, '2023-02-15', 'Room cleaning', 50.00, 1),
       (2, '2023-02-16', 'Laundry', 25.00, 2),
       (3, '2023-02-17', 'Room service', 30.00, 3);


/* We need to disable the foreign key contstrain  
for the current session, otherwise it will give us
 error 1452  when we run the rest of code */
SET FOREIGN_KEY_CHECKS=0;

-- Populating Reservation table
INSERT INTO Reservation (ReservationID, CustomerID, RoomID, CheckInDate, CheckOutDate, Price, PaymentID, FeedbackID)
VALUES
(1, 1, 1, '2023-02-20', '2023-02-25', 500.00, 1, 1),
(2, 2, 2, '2023-03-10', '2023-03-12', 200.00, 2, 2),
(3, 3, 3, '2023-04-05', '2023-04-09', 800.00, 3, 3),
(4, 4, 4, '2023-05-01', '2023-05-05', 700.00, 4, 4),
(5, 5, 5, '2023-06-15', '2023-06-20', 550.00, 5, 5),
(6, 6, 6, '2023-07-02', '2023-07-07', 600.00, 6, 6);


-- Populating Payment table
INSERT INTO Payment (PaymentID, ReservationID, PaymentAmount, PaymentMethod, PaymentDate)
VALUES (1, 0, 100.00, 'Credit card', '2023-02-15'),
       (2, 0, 150.00, 'Debit card', '2023-02-16'),
       (3, 0, 200.00, 'Cash', '2023-02-17');



-- Populating Feedback table
INSERT INTO Feedback (FeedbackID, ReservationID, CustomerID, Comments, Ratings, Suggestions, FeedbackDate)
VALUES (1, 1, 1, 'Great experience overall!', 5, 'None', '2023-02-15'),
       (2, 2, 2, 'Could be better', 3, 'Improve room cleaning', '2023-02-16'),
       (3, 3, 3, 'Excellent service!', 5, 'None', '2023-02-17');


-- Populating Shift table
INSERT INTO Shift (ShiftID, StaffID, ShiftDate)
VALUES (1, 1, '2022-01-01'),
(2, 2, '2022-01-02'),
(3, 3, '2022-01-03');


-- # List of all customers along with their contact information (name, address, phone number, email)

SELECT *
FROM Customer;

-- # List of all reservations with their corresponding check-in and check-out dates and the
-- # associated customer information

SELECT Reservation.ReservationID, Customer.Name, Customer.PhoneNumber, Customer.Email, Reservation.CheckInDate, Reservation.CheckOutDate
FROM Reservation
INNER JOIN Customer ON Reservation.CustomerID = Customer.CustomerID;

-- # Total revenue generated by the hotel within a specified time period

SELECT SUM(PaymentAmount) AS TotalRevenue
FROM Payment
INNER JOIN Reservation ON Payment.ReservationID = Reservation.ReservationID
WHERE PaymentDate BETWEEN 'start_date' AND 'end_date';
-- Note: Replace 'start_date' and 'end_date' with the desired time period.

-- # List of all rooms along with their corresponding room numbers, types, -- and rates

SELECT *
FROM Room;

-- # List of all service requests along with the service type, date, cost,
-- # and the associated customer information

SELECT ServiceRequests.ServiceRequestID, Customer.Name, Customer.PhoneNumber, Customer.Email, ServiceRequests.RequestDate, ServiceRequests.ServiceType, ServiceRequests.ServiceCost
FROM ServiceRequests
INNER JOIN Customer ON ServiceRequests.CustomerID = Customer.CustomerID;

-- # List of all staff members along with their contact information and  positions

SELECT *
FROM Staff;

-- # Average rating of the hotel based on all customer feedback

SELECT AVG(Ratings) AS AvgRating
FROM Feedback;

-- # List of all reservations made by a specific customer, along with the associated room information, 
-- # payment details, and feedback (if available)

SELECT Reservation.ReservationID, Room.RoomNumber, Room.RoomType, Room.RoomRate, Reservation.CheckInDate, Reservation.CheckOutDate, Payment.PaymentMethod, Payment.PaymentAmount, Feedback.Comments, Feedback.Ratings, Feedback.Suggestions
FROM Reservation
INNER JOIN Room ON Reservation.RoomID = Room.RoomID
LEFT JOIN Payment ON Reservation.PaymentID = Payment.PaymentID
LEFT JOIN Feedback ON Reservation.FeedbackID = Feedback.FeedbackID
WHERE Reservation.CustomerID = 'customer_id';
-- Note: Replace 'customer_id' with the desired customer ID.

-- # List of all shifts worked by a specific staff member along with the ---- date 
-- # and the associated staff and room information

SELECT Shift.ShiftID, Staff.Name, Staff.Position, Room.RoomNumber, Room.RoomType, Room.RoomRate, Shift.ShiftDate
FROM Shift
INNER JOIN Staff ON Shift.StaffID = Staff.StaffID
INNER JOIN Reservation ON Shift.ShiftDate BETWEEN Reservation.CheckInDate AND Reservation.CheckOutDate
INNER JOIN Room ON Reservation.RoomID = Room.RoomID
WHERE Staff.StaffID = 'staff_id';
-- Note: Replace 'staff_id' with the desired staff ID.

-- #Total revenue generated by the hotel from a specific room type within a -- specified time period

SELECT SUM(PaymentAmount) AS TotalRevenue
FROM Payment
INNER JOIN Reservation ON Payment.ReservationID = Reservation.ReservationID
INNER JOIN Room ON Reservation.RoomID = Room.RoomID
WHERE Room.RoomType = 'room_type' AND PaymentDate BETWEEN 'start_date' AND 'end_date';
-- Note: Replace 'room_type', 'start_date', and 'end_date' with the desired -- room type and time period.a
