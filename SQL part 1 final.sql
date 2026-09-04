CREATE DATABASE RaceDayDB;

USE RaceDayDB;
--organisers
CREATE TABLE Organisers (
    OrganiserID     INT IDENTITY(1,1)   PRIMARY KEY,
    FullName  VARCHAR(100)   NOT NULL,
    Email  VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash  VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20)  NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

 

   -- Participants
 
CREATE TABLE Participants (
    ParticipantID   INT IDENTITY(1,1)   PRIMARY KEY,
    FullName  VARCHAR(100)  NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255)  NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

 

   --Events  (created and owned by an Organiser)
  
CREATE TABLE Events (
    EventID   INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID  INT  NOT NULL,
    EventName  VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(150) NOT NULL,
    Description VARCHAR(MAX) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Organiser FOREIGN KEY (OrganiserID)
    REFERENCES Organisers(OrganiserID)
);

 

   --4. Categories  (belongs to one Event)
 
CREATE TABLE Categories (
    CategoryID  INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT  NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    DistanceKM DECIMAL(5,2) NOT NULL,
    EntryFee DECIMAL(8,2) NOT NULL DEFAULT 0,
    MaxParticipants INT NOT NULL DEFAULT 100,
    CONSTRAINT FK_Categories_Event FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
);

 

  -- 5. Routes 
  
CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1)   PRIMARY KEY,
    CategoryID  INT  NOT NULL UNIQUE,
    StartPoint  VARCHAR(150)  NOT NULL,
    EndPoint VARCHAR(150) NOT NULL,
    ElevationGainM  INT NULL DEFAULT 0,
    MapURL  VARCHAR(255) NULL,
    CONSTRAINT FK_Routes_Category FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

 

  -- 6. Enrolments 
  
CREATE TABLE Enrolments (
    EnrolmentID INT IDENTITY(1,1)   PRIMARY KEY,
    ParticipantID   INT NOT NULL,
    CategoryID  INT NOT NULL,
    EnrolmentDate  DATETIME NOT NULL DEFAULT GETDATE(),
    RaceNumber VARCHAR(20) NOT NULL UNIQUE,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending'
    CONSTRAINT CK_Enrolments_Status CHECK (Status IN ('Pending','Confirmed','Cancelled')),
    CONSTRAINT FK_Enrolments_Participant FOREIGN KEY (ParticipantID)
    REFERENCES Participants(ParticipantID),
    CONSTRAINT FK_Enrolments_Category FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID)
);

 

   --7. Results  (one result per Enrolment)
  
CREATE TABLE Results (
    ResultID  INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID  INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    ChipTime TIME NULL,
    Position  INT NULL,
    CapturedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolment FOREIGN KEY (EnrolmentID)
    REFERENCES Enrolments(EnrolmentID)
);
 

 --insert
   
 
--organisers
INSERT INTO Organisers (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Kamogelo Mashigo', 'skamza.mokoena@raceday.co.za', 'hashed_pw_1', '0821234567'),
('Lesedi Mpulo', 'Lereto.vdm@raceday.co.za', 'hashed_pw_2', '0837654321');
GO
 
--participants
INSERT INTO Participants (FullName, Email, PasswordHash, PhoneNumber) VALUES
('Lindani Molete', 'lindan.dube@example.com', 'hashed_pw_3', '0729876543'),
('Mpho Mpe', 'mpe.nkosi@example.com', 'hashed_pw_4', '0611239876');
GO
 
--events
INSERT INTO Events (OrganiserID, EventName, EventDate, Location, Description) VALUES
(1, 'Joburg Marathon', '2026-12-15', 'Johannesburg, Gauteng', 'Annual road marathon of Johannesburg.'),
(2, 'Winelands Cycle Tour', '2026-07-16', 'Stellenbosch, Western Cape', 'cycling tour Cape Winelands.'),
(1, 'Soweto Fun Walk', '2026-01-11', 'Soweto, Gauteng', 'charity walk local youth programmes.'),
(2, 'Walk of Bedfordview', '2026-10-12', 'Bedfordview, Gauteng', 'charity run program.');
GO
 
--categories
INSERT INTO Categories (EventID, CategoryName, DistanceKM, EntryFee, MaxParticipants) VALUES
(1, '11km', 10.00, 150.00, 2000),
(1, 'Half Marathon', 21.10, 250.00, 3000),
(1, 'Full Marathon', 42.20, 350.00, 1500),
(2, '55km Road Cycle', 50.00, 300.00, 800),
(2, '101km Road Cycle', 100.00, 450.00, 500),
(3, '6km Fun Walk', 5.00, 50.00, 1000);
GO
 
--routes
INSERT INTO Routes (CategoryID, StartPoint, EndPoint, ElevationGainM, MapURL) VALUES
(1, 'Sandton City', 'Marks Park Sports Club', 120, 'https://maps.google.com/route/1'),
(2, 'Sandton City', 'Ellis Park Stadium', 210, 'https://maps.google.com/route/2'),
(3, 'Sandton City', 'FNB Stadium', 340, 'https://maps.google.com/route/3'),
(4, 'Stellenbosch Square', 'Franschhoek Village', 480, 'https://maps.google.com/route/4'),
(5, 'Stellenbosch Square', 'Paarl Rock', 650, 'https://maps.google.com/route/5'),
(6, 'Soweto Theatre', 'Orlando Stadium', 40, 'https://maps.google.com/route/6');
GO
 
--enrolments
INSERT INTO Enrolments (ParticipantID, CategoryID, RaceNumber, Status) VALUES
(1, 2, 'RD-1001', 'Confirmed'),
(2, 1, 'RD-1002', 'Confirmed'),
(1, 6, 'RD-1003', 'Pending'),
(2, 4, 'RD-1004', 'Confirmed');
GO
 
--results (one per enrolment)
INSERT INTO Results (EnrolmentID, FinishTime, ChipTime, Position) VALUES
(1, '01:52:30', '01:51:47', 42),
(2, '00:48:15', '00:47:58', 15),
(3, '00:35:20', '00:34:58', 8),
(4, '02:41:10', '02:40:02', 63);
GO
 
  -- Verification queries

SELECT * FROM Organisers;
SELECT * FROM Participants;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM Routes;
SELECT * FROM Enrolments;
SELECT * FROM Results;