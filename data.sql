USE `pulse_fest`;


-- Static 
 INSERT INTO RoleType VALUES (1,'Technician'),(2,'Security'),(3,'Auxiliary');

 INSERT INTO ExpLevel VALUES (1,'Trainee'),(2,'Junior'),(3,'Mid'),(4,'Senior'),(5,'Expert');

 INSERT INTO PerformerType VALUES (1,'Artist'),(2,'Band');

 INSERT INTO PerfSlotType VALUES (1,'WarmUp'),(2,'Headline'),(3,'SpecialGuest');

 INSERT INTO PaymentMethod VALUES (1,'CreditCard'),(2,'DebitCard'),(3,'BankTransfer'), (4, 'CryptoTransfer');

 INSERT INTO TicketCategory VALUES (1,'General',100.00),(2,'VIP',10.00),(3,'Backstage',5.00);





-- Location

INSERT INTO Continent(Continent) VALUES ('Europe'), ('North America'), ('Asia');

INSERT INTO Country (Country, ContinentID) VALUES ('Greece', 1), ('Germany', 1), ('Italy', 1), ('USA', 2), ('Canada', 2), ('Mexico', 2), ('Japan', 3), ('China', 3), ('Korea', 3);

INSERT INTO City (City, CountryID) VALUES ('Athens', 1), ('Thessaloniki', 1), ('Volos', 1), ('Berlin',2), ('Munich', 2), ('Hamburg', 2), ('Rome', 3), ('Milano', 3), ('Napoli', 3), ('Dallas', 4), ('Ottowa', 5), ('Mexico City', 6), ('Tokyo', 7), ('Beijing', 8), ('Seoul', 9);

INSERT INTO Address(Address, CityID) VALUES ('Elasidon 6', 1), ('Elasidon 7', 1), ('Elasidon 8', 1), ('Berlin Address 1', 4), ('Berlin Address 2', 4), ('Berlin Address 3', 4),('Dallas Address 1', 10), ('Dallas Adress 2', 10), ('Dallas Address 3', 10), ('Tokyo Street', 13), ('Seoul Street', 15);

INSERT INTO Location (Latitude, Longitude, AddressID) VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4), (5,5,5), (6,6,6), (7,7,7), (8,8,8), (9,9,9), (10,10,10),(11,11,11);



-- Festival
INSERT INTO Festival(FestivalID, Name, StartDate, EndDate, LocationID,ContinentID) VALUES
(2015, '2015 Pulse Festival', '2015-07-10', '2015-7-13', 11,3),
(2016, '2016 Pulse Festival', '2016-10-04', '2016-10-09', 2, 1), 
(2017, '2017 Pulse Festival', '2017-08-16', '2017-08-19', 1, 1), 
(2018, '2018 Pulse Festival', '2018-08-16', '2018-08-19', 4, 1),
(2019, '2019 Pulse Festival', '2019-08-16', '2019-08-19', 7, 2),
(2020, 'Corona? The beer?', '2020-08-16', '2020-08-19', 10, 3),
(2021, '2021 Pulse Festival', '2021-02-19', '2021-02-25', 4, 1),
(2022, '2022 Pulse Festival', '2022-05-12', '2022-05-16', 4, 1),
(2023, '2023 Pulse Festival', '2023-10-14', '2023-10-19', 4, 1),
(2024, '2024 Pulse Festival', '2024-10-15', '2024-10-22', 4, 1),
(2025, '2025 Pulse Festival', '2025-10-17', '2025-10-19', 4 ,1),
(2026, '2026 Pulse Festival', '2026-04-08', '2026-04-14', 4, 1),
(2027, '2027 Pulse Festival', '2027-07-10', '2027-07-12', 4, 1),
(2028, '2028 Pulse Festival', '2028-10-15', '2028-10-23', 4, 1),
(2029, '2029 Pulse Festival', '2029-05-11', '2029-05-13', 4, 1);



-- Stage
INSERT INTO Stage(Name, Description, Capacity, LocationID) VALUES 
('Name 1', 'Description 1', 10000, 1),
('Name 2', 'Description 2', 1000, 2),
('Name 1 IN AMERICA', 'Description 1 IN AMERICA', 10000, 8),
('Name 1 IN JAPAN', 'Description 1 IN JAPAN', 5000, 10),
('Name 1 IN BERLIN', 'Description 1 IN BERLIN', 100, 4);

-- Performer
INSERT INTO Performer(TypeID) VALUES (1), (1), (1), (2), (2), (1), (1), (1);

-- Artist
INSERT INTO Artist(PerformerID,RealName, StageName, BirthDate, Website, Instagram) VALUES 
(1,'J','j', '2000-01-01', 'url','@'), 
(2,'J','j', '2000-01-01', 'url','@'), 
(3,'J','j', '2000-01-01', 'url','@'),
(6,'J','j', '2000-01-01', 'url','@'),
(7,'J','j', '2000-01-01', 'url','@'),
(8,'J','j', '2000-01-01', 'url','@');

INSERT INTO Band(PerformerID, BandName, FormationDate, Website, Instagram) VALUES 
(4,'Band 1', '2001-01-01', 'url', '@'),
(5,'Band 2', '2001-01-01', 'url', '@');

INSERT INTO BandMember(BandID, ArtistID) VALUES (4,1),
(4,2);

-- Genres
INSERT INTO Genre(Name) VALUES ('Rock'), ('Pop');

-- Performer Genres
INSERT INTO PerformerGenre(PerformerID, GenreID) VALUES 
(1,1),
(2,2);


-- Event
INSERT INTO Event(FestivalID,StageID, StartTS, EndTS) VALUES
(2017, 1, '2017-08-16 12:00:00', '2017-08-16 13:00:00'),
(2017, 1, '2017-08-17 12:00:00', '2017-08-17 13:00:00'),
(2017, 1, '2017-08-18 12:00:00', '2017-08-18 13:00:00'),
(2019, 3, '2019-08-16 12:00:00', '2019-08-16 13:00:00'),
(2020, 4, '2020-08-16 12:00:00', '2020-08-16 13:00:00'),
(2021, 5, '2021-02-19 12:00:00', '2021-02-19 13:00:00')
;
-- Performance Slot
INSERT INTO PerformanceSlot(EventID,PerformerID, SlotTypeID, StartTS, DurationMin, SeqNo, GenreID) VALUES 
(1,1,1,'2017-08-16 12:00:00', 60, 1,1),
(2,1,1,'2017-08-17 12:00:00', 60, 1, 1),
(3,1,1,'2017-08-18 12:00:00', 60, 1, 1),
(4,1,1,'2019-08-16 12:00:00', 60, 1,1),
(5,1,1,'2020-08-16 12:00:00', 60, 1,1),
(6,2,1,'2021-02-19 12:00:00', 60, 1, 1);


-- HR
INSERT INTO Personnel(FullName, BirthDate) VALUES
('John Doe', '2001-01-01'),
('Jane Doe', '2001-01-01');

INSERT INTO Assignment (PersonID, SlotID, RoleID, ExpID) VALUES
(1,1,1,1),
(2,1,3,2);

-- Ticket Cost


-- Visitor 
INSERT INTO Visitor(FullName, Contact, BirthDate) VALUES 
('John', 'Phone: 210', '1990-09-09'),
('John1', 'Phone: 210', '1990-09-09'),
('John2', 'Phone: 210', '1990-09-09'),
('John3', 'Phone: 210', '1990-09-09');


-- Ticket

INSERT INTO TicketCost(CategoryID, EventID, Cost) VALUES 
(1,1,100),
(2,2, 500),
(3,3, 1000),
(1,2, 250);

INSERT INTO Ticket(TicketEAN, VisitorID, EventID, CategoryID, PurchaseTS, MethodID, Activated) VALUES 
(1234567890123, 1, 1, 1, '2017-06-01 10:00:00', 1, TRUE),
(1234567890122, 2, 1, 2, '2017-06-01 10:00:01', 2, TRUE),
(1234567890121, 3, 1, 1, '2017-06-01 10:00:02', 3, TRUE),
(1234567890120, 4, 4, 1, '2019-06-01 10:00:00', 4, TRUE)
;

INSERT INTO Rating(TicketEAN, SlotID, ScorePerformer, ScoreSoundLight, ScoreScenePresence, ScoreOrganization, ScoreOverall) VALUES
(1234567890123, 1, 1,1,1,1,1),
(1234567890122, 2, 5,5,5,5,5)
;
