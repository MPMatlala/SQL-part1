
--creating the database 
CREATE DATABASE RaceDayDB;

USE RaceDayDB;

--organiser table
CREATE TABLE Organisers (
    OrganiserID  INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255)  NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt  DATETIME  NOT NULL DEFAULT GETDATE()
);
--participaint table
CREATE TABLE Participants (
    ParticipantID   INT IDENTITY(1,1) PRIMARY KEY,
    FullName  VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20)  NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
--event
CREATE TABLE Events (
    EventID  INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID  INT  NOT NULL,
    EventName  VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(150) NOT NULL,
    Description VARCHAR(MAX) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserID)
    REFERENCES Organisers(OrganiserID)
);
--categories
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1)PRIMARY KEY,
    EventID  INT NOT NULL,
    CategoryName  VARCHAR(100)  NOT NULL,
    DistanceKM DECIMAL(5,2) NOT NULL,
    EntryFee   DECIMAL(8,2) NOT NULL DEFAULT 0,
    MaxParticipants INT  NOT NULL DEFAULT 100,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventID)
    REFERENCES Events(EventID)
);
--routes table
CREATE TABLE Routes (
    RouteID  INT IDENTITY(1,1)   PRIMARY KEY,
    CategoryID  INT NOT NULL UNIQUE,
    StartPoint  VARCHAR(150) NOT NULL,
    EndPoint  VARCHAR(150) NOT NULL,
    ElevationGainM  INT NULL DEFAULT 0,
    MapURL VARCHAR(255) NULL,
    CONSTRAINT FK_Routes_Category FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID)
);
--Enrolment table
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1)   PRIMARY KEY,
    ParticipantID   INT  NOT NULL,
    CategoryID  INT  NOT NULL,
    EnrolmentDate   DATETIME  NOT NULL DEFAULT GETDATE(),
    RaceNumber  VARCHAR(20) NOT NULL UNIQUE,
    Status  VARCHAR(20) NOT NULL DEFAULT 'Pending'
    CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Pending','Confirmed','Cancelled')),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantID)
    REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID)
);
--result table
CREATE TABLE Results (
    ResultID  INT IDENTITY(1,1)   PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    ChipTime TIME NULL,
    Position INT NULL,
    CapturedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID)
    REFERENCES Enrolments(EnrolmentID)
);
-- categories per event 
--organisers
INSERT INTO Organisers (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Messiah Matlala', 'phaswanamatlala@gmail.com', 'phaswana_12_1', '0813867961'),
('Kamogelo Mashego', 'mashigo1234@gmail,com', 'hashed_pw_2', '0889871234');
--participants
INSERT INTO Participants (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Micheal Jackson', 'michealjackson@gmail.com', 'money_pw_3', '0724567893'),
('Nathan Nkosi', 'nathannkosi@example.com', 'hashed_pw_3', '0615437890'),
('Atli Mpopedi', 'AtliMpopedi@example.com', 'mmom_pw_5', '0616850123'),
('Lesedi mabet', 'Lesedimabet@example.com', 'sedi_pw_4', '0611237890');
--events
INSERT INTO Events (OrganiserID, EventName, EventDate, Location, Description) VALUES
(1, 'Joburg Marathon', '2026-12-15', 'Johannesburg, Gauteng', 'Annual road marathon of Johannesburg.'),
(2, 'Winelands Cycle Tour', '2026-16-07', 'Stellenbosch, Western Cape', 'cycling tour Cape Winelands.'),
(1, 'Soweto Fun Walk', '2026-12-20', 'Soweto, Gauteng', 'charity walk local youth programmes.'),
(2, 'Walk of Bedfordview', '2026-10-20', 'Bedfordview, Gauteng', 'charity run program.');
--categories
INSERT INTO Categories (EventID, CategoryName, DistanceKM, EntryFee, MaxParticipants) VALUES
(1, '11km', 10.00, 150.00, 2000),
(1, 'Half Marathon', 21.10, 250.00, 3000),
(1, 'Full Marathon', 42.20, 350.00, 1500),
(2, '55km Road Cycle', 50.00, 300.00, 800),
(2, '101km Road Cycle', 100.00, 450.00, 500),
(3, '6km Fun Walk', 5.00, 50.00, 1000);
--routes
INSERT INTO dbo.Routes (CategoryID, StartPoint, EndPoint, ElevationGainM, MapURL) VALUES
(1, 'Sandton City', 'Marks Park Sports Club', 120, 'https://maps.google.com/route/1'),
(2, 'Sandton City', 'Ellis Park Stadium', 210, 'https://maps.google.com/route/2'),
(3, 'Sandton City', 'FNB Stadium', 340, 'https://maps.google.com/route/3'),
(4, 'Stellenbosch Square', 'Franschhoek Village', 480, 'https://maps.google.com/route/4'),
(5, 'Stellenbosch Square', 'Paarl Rock', 650, 'https://maps.google.com/route/5'),
(6, 'Soweto Theatre', 'Orlando Stadium', 40, 'https://maps.google.com/route/6');
--enrolments
INSERT INTO Enrolments (ParticipantID, CategoryID, RaceNumber, Status) VALUES
(1, 2, 'RD-1001', 'Confirmed'),
(2, 1, 'RD-1002', 'Confirmed'),
(1, 6, 'RD-1003', 'Pending'),
(2, 4, 'RD-1004', 'Confirmed');
--results
INSERT INTO Results (EnrolmentID, FinishTime, ChipTime, Position) VALUES
(1, '01:52:30', '01:51:47', 42),
(2, '00:48:15', '00:47:58', 15),
(3, '01:48:45', '01:40;50',16),
(4, '00:41:40', '00:35:20',14);
--verification and running the methods 
SELECT * FROM Organisers;
SELECT * FROM Participants;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM Routes;
SELECT * FROM Enrolments;
SELECT * FROM Results;
