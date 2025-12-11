-- ===================================================
-- 0. Create database and drop existing schema
-- ===================================================
CREATE DATABASE IF NOT EXISTS `pulse_fest`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `pulse_fest`;

SET FOREIGN_KEY_CHECKS = 0;
-- Drop triggers, functions, and tables to rebuild schema
DROP TRIGGER IF EXISTS trg_event;
DROP TRIGGER IF EXISTS trg_slot;
DROP TRIGGER IF EXISTS trg_tech;
DROP TRIGGER IF EXISTS trg_ticket;
DROP TRIGGER IF EXISTS trg_ticket_ean;
DROP TRIGGER IF EXISTS trg_rating;
DROP FUNCTION IF EXISTS f_minutes_day;

DROP TABLE IF EXISTS Rating,
                 BuyerQueue,
                 SellerQueue,
                 Ticket,
                 TicketCategory,
                 TicketCost,
                 Visitor,
                 Assignment,
                 Personnel,
                 PerformanceSlot,
                 Event,
                 BandMember,
                 Band,
                 Artist,
                 PerformerSubgenre,
                 PerformerGenre,
                 Subgenre,
                 Genre,
                 Performer,
                 StageEquipment,
                 Equipment,
                 Stage,
                 Festival,
                 Location,
                 Address,
                 City,
                 Country,
                 Continent,
                 FestivalImage,
                 PerformanceImage,
                 PerformerImage,
                 Image,
                 RoleType,
                 ExpLevel,
                 PerformerType,
                 PerfSlotType,
                 PaymentMethod;

SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================
-- 1. Static reference tables
-- ===================================================
CREATE TABLE RoleType (
  RoleID    TINYINT PRIMARY KEY,
  Name      VARCHAR(20) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE ExpLevel (
  ExpID     TINYINT PRIMARY KEY,
  Name      VARCHAR(20) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE PerformerType (
  TypeID    TINYINT PRIMARY KEY,
  Name      VARCHAR(10) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE PerfSlotType (
  SlotTypeID TINYINT PRIMARY KEY,
  Name       VARCHAR(15) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE PaymentMethod (
  MethodID  TINYINT PRIMARY KEY,
  Name      VARCHAR(15) UNIQUE
) ENGINE=InnoDB;

CREATE TABLE TicketCategory (
  CategoryID  TINYINT PRIMARY KEY,
  Name        VARCHAR(50) UNIQUE NOT NULL,
  MaxPercent  DECIMAL(5,2) NOT NULL  -- percent of capacity
) ENGINE=InnoDB;



-- ===================================================
-- 2. Geography & festival
-- ===================================================
CREATE TABLE Continent(
  ContinentID TINYINT AUTO_INCREMENT PRIMARY KEY,
  Continent VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE Country(
  CountryID INT AUTO_INCREMENT PRIMARY KEY,
  Country VARCHAR(100) NOT NULL,
  ContinentID TINYINT NOT NULL,
  FOREIGN KEY (ContinentID) REFERENCES Continent(ContinentID)
) ENGINE = InnoDB;

CREATE TABLE City (
  CityID INT AUTO_INCREMENT PRIMARY KEY,
  City VARCHAR(100) NOT NULL,
  CountryID INT NOT NULL,
  FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
) ENGINE = InnoDB;
 
CREATE TABLE Address(
  AddressID INT AUTO_INCREMENT PRIMARY KEY,
  Address VARCHAR(255) NOT NULL,
  CityID INT NOT NULL,
  FOREIGN KEY (CityID) REFERENCES City(CityID)
) ENGINE = InnoDB;
 
CREATE TABLE Location (
  LocationID INT AUTO_INCREMENT PRIMARY KEY,
  Latitude   DECIMAL(9,6) NOT NULL,
  Longitude  DECIMAL(9,6) NOT NULL,
  AddressID    INT NOT NULL,
  FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
) ENGINE=InnoDB;
 
CREATE TABLE Festival (
  FestivalID  INT AUTO_INCREMENT PRIMARY KEY,
  Name        VARCHAR(200) NOT NULL,
  StartDate   DATE NOT NULL,
  EndDate     DATE NOT NULL,
  LocationID  INT NOT NULL ,-- UNIQUE,
  ContinentID TINYINT NOT NULL  ,
  FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
  FOREIGN KEY (ContinentID) REFERENCES Continent(ContinentID)
) ENGINE=InnoDB;
-- ===================================================
-- 3. Stages & equipment
-- ===================================================
CREATE TABLE Stage (
  StageID     INT AUTO_INCREMENT PRIMARY KEY,
  Name        VARCHAR(200) NOT NULL,
  Description TEXT,
  Capacity    INT NOT NULL,
  LocationID  INT NOT NULL,
  FOREIGN KEY (LocationID) REFERENCES Location(LocationID)
) ENGINE=InnoDB;

CREATE TABLE Equipment (
  EquipmentID INT AUTO_INCREMENT PRIMARY KEY,
  Name        VARCHAR(150) NOT NULL,
  Description TEXT
) ENGINE=InnoDB;

CREATE TABLE StageEquipment (
  StageID     INT NOT NULL,
  EquipmentID INT NOT NULL,
  Quantity    INT NOT NULL,
  PRIMARY KEY (StageID, EquipmentID),
  FOREIGN KEY (StageID) REFERENCES Stage(StageID),
  FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
) ENGINE=InnoDB;

-- ===================================================
-- 4. Performers & genres
-- ===================================================
CREATE TABLE Performer (
  PerformerID INT AUTO_INCREMENT PRIMARY KEY,
  TypeID      TINYINT NOT NULL,
  FOREIGN KEY (TypeID) REFERENCES PerformerType(TypeID)
) ENGINE=InnoDB;

CREATE TABLE Artist (
  PerformerID INT PRIMARY KEY,
  RealName    VARCHAR(200) NOT NULL,
  StageName   VARCHAR(200),
  BirthDate   DATE,
  Website     VARCHAR(255),
  Instagram   VARCHAR(255),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID)
) ENGINE=InnoDB;

CREATE TABLE Band (
  PerformerID   INT PRIMARY KEY,
  BandName      VARCHAR(200) NOT NULL,
  FormationDate DATE,
  Website       VARCHAR(255),
  Instagram     VARCHAR(255),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID)
) ENGINE=InnoDB;

CREATE TABLE BandMember (
  BandID   INT NOT NULL,
  ArtistID INT NOT NULL,
  PRIMARY KEY (BandID, ArtistID),
  FOREIGN KEY (BandID)   REFERENCES Band(PerformerID),
  FOREIGN KEY (ArtistID) REFERENCES Artist(PerformerID)
) ENGINE=InnoDB;

CREATE TABLE Genre (
  GenreID INT AUTO_INCREMENT PRIMARY KEY,
  Name    VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Subgenre (
  SubID   INT AUTO_INCREMENT PRIMARY KEY,
  Name    VARCHAR(100) UNIQUE NOT NULL,
  GenreID INT NOT NULL,
  FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
) ENGINE=InnoDB;

CREATE TABLE PerformerGenre (
  PerformerID INT NOT NULL,
  GenreID     INT NOT NULL,
  PRIMARY KEY (PerformerID, GenreID),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID),
  FOREIGN KEY (GenreID)     REFERENCES Genre(GenreID)
) ENGINE=InnoDB;

CREATE TABLE PerformerSubgenre (
  PerformerID INT NOT NULL,
  SubID       INT NOT NULL,
  PRIMARY KEY (PerformerID, SubID),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID),
  FOREIGN KEY (SubID)       REFERENCES Subgenre(SubID)
) ENGINE=InnoDB;

-- ===================================================
-- 5. Scheduling
-- ===================================================
CREATE TABLE Event (
  EventID    INT AUTO_INCREMENT PRIMARY KEY,
  FestivalID INT NOT NULL,
  StageID    INT NOT NULL,
  StartTS    DATETIME NOT NULL,
  EndTS      DATETIME NOT NULL,
  FOREIGN KEY (FestivalID) REFERENCES Festival(FestivalID),
  FOREIGN KEY (StageID)    REFERENCES Stage(StageID),
  INDEX idx_Event_StageTime (StageID, StartTS)
) ENGINE=InnoDB;

CREATE TABLE PerformanceSlot (
  SlotID      INT AUTO_INCREMENT PRIMARY KEY,
  EventID     INT NOT NULL,
  PerformerID INT NOT NULL,
  SlotTypeID  TINYINT NOT NULL,
  StartTS     DATETIME NOT NULL,
  DurationMin INT NOT NULL,
  SeqNo       INT NOT NULL,
  GenreID     INT NOT NULL,       
  FOREIGN KEY (EventID)     REFERENCES Event(EventID),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID),
  FOREIGN KEY (SlotTypeID)  REFERENCES PerfSlotType(SlotTypeID),
  FOREIGN KEY (GenreID)     REFERENCES Genre(GenreID),
  INDEX idx_Perf_PrfTime (PerformerID, StartTS)
) ENGINE=InnoDB;

-- ===================================================
-- 6. Human resources
-- ===================================================
CREATE TABLE Personnel (
  PersonID INT AUTO_INCREMENT PRIMARY KEY,
  FullName VARCHAR(200) NOT NULL,
  BirthDate DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Assignment (
  PersonID     INT NOT NULL,
  SlotID       INT NOT NULL,
  RoleID       TINYINT NOT NULL,
  ExpID        TINYINT NOT NULL,
  PRIMARY KEY (PersonID, SlotID),
  FOREIGN KEY (PersonID) REFERENCES Personnel(PersonID),
  FOREIGN KEY (SlotID)   REFERENCES PerformanceSlot(SlotID),
  FOREIGN KEY (RoleID)   REFERENCES RoleType(RoleID),
  FOREIGN KEY (ExpID)    REFERENCES ExpLevel(ExpID)
) ENGINE=InnoDB;

-- ===================================================
-- 7. Visitors & ticketing
-- ===================================================
CREATE TABLE Visitor (
  VisitorID INT AUTO_INCREMENT PRIMARY KEY,
  FullName VARCHAR(100) NOT NULL,
  Contact   VARCHAR(255),
  BirthDate   DATE
) ENGINE=InnoDB;


CREATE TABLE TicketCost (
  CategoryID TINYINT,
  EventID    INT NOT NULL,
  Cost INT NOT NULL,
  PRIMARY KEY(CategoryID, EventID),
  FOREIGN KEY(CategoryID) REFERENCES TicketCategory(CategoryID),
  FOREIGN KEY (EventID)   REFERENCES Event(EventID)
) ENGINE=InnoDB;

CREATE TABLE Ticket (
  TicketEAN  BIGINT PRIMARY KEY,
  VisitorID  INT NOT NULL,
  EventID    INT NOT NULL,
  CategoryID TINYINT NOT NULL,
  PurchaseTS DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MethodID   TINYINT NOT NULL,
  Activated  BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE KEY uq_visitor_event (VisitorID, EventID),
  FOREIGN KEY (VisitorID)  REFERENCES Visitor(VisitorID),
  FOREIGN KEY (EventID)    REFERENCES Event(EventID),
  FOREIGN KEY (CategoryID) REFERENCES TicketCategory(CategoryID),
  FOREIGN KEY (MethodID)   REFERENCES PaymentMethod(MethodID),
  CHECK (TicketEAN BETWEEN 1000000000000 AND 9999999999999)
) ENGINE=InnoDB;

CREATE TABLE SellerQueue (
  SellerQueueID   INT AUTO_INCREMENT PRIMARY KEY,
  EventID INT  NOT NULL,
  TicketEAN BIGINT NOT NULL,
  SellerID  INT NOT NULL,
  RequestTS DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (TicketEAN) REFERENCES Ticket(TicketEAN),
  FOREIGN KEY (EventID) REFERENCES Event(EventID),
  FOREIGN KEY (SellerID)  REFERENCES Visitor(VisitorID)
) ENGINE=InnoDB;

CREATE TABLE BuyerQueue (
  InterestID INT AUTO_INCREMENT PRIMARY KEY,
  BuyerID    INT NOT NULL,
  EventID    INT NOT NULL,
  CategoryID TINYINT,
  SpecificEAN BIGINT,
  RequestTS  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (BuyerID)    REFERENCES Visitor(VisitorID),
  FOREIGN KEY (EventID)    REFERENCES Event(EventID),
  FOREIGN KEY (CategoryID) REFERENCES TicketCategory(CategoryID)
) ENGINE=InnoDB;




CREATE TABLE Rating (
  RatingID            INT AUTO_INCREMENT PRIMARY KEY,
  TicketEAN           BIGINT NOT NULL,
  SlotID              INT NOT NULL,
  ScorePerformer     TINYINT NOT NULL,
  ScoreSoundLight     TINYINT NOT NULL,
  ScoreScenePresence       TINYINT NOT NULL,
  ScoreOrganization   TINYINT NOT NULL,
  ScoreOverall        TINYINT NOT NULL,
  FOREIGN KEY (TicketEAN) REFERENCES Ticket(TicketEAN),
  FOREIGN KEY (SlotID)   REFERENCES PerformanceSlot(SlotID),
  CHECK (ScorePerformer BETWEEN 1 AND 5),
  CHECK (ScoreSoundLight BETWEEN 1 AND 5),
  CHECK (ScoreScenePresence BETWEEN 1 AND 5),
  CHECK (ScoreOrganization BETWEEN 1 AND 5),
  CHECK (ScoreOverall BETWEEN 1 AND 5)
) ENGINE=InnoDB;


-- -------------------------------------
-- Images 
-- -------------------------------------
CREATE TABLE Image (
  ImageID INT AUTO_INCREMENT PRIMARY KEY,
  URL     VARCHAR(255) NOT NULL,
  Description TEXT
) ENGINE=InnoDB;


CREATE TABLE FestivalImage (
  FestivalID INT NOT NULL,
  ImageID INT NOT NULL,
  PRIMARY KEY (FestivalID, ImageID),
  FOREIGN KEY (FestivalID) REFERENCES Festival(FestivalID),
  FOREIGN KEY (ImageID) REFERENCES Image(ImageID)
) ENGINE = InnoDB;

CREATE TABLE PerformanceImage(
  SlotID INT NOT NULL, 
  ImageID INT NOT NULL,
  PRIMARY KEY (SlotID, ImageID),
  FOREIGN KEY (SlotID) REFERENCES PerformanceSlot(SlotID),
  FOREIGN KEY (ImageID) REFERENCES Image(ImageID)
) ENGINE = InnoDB;

CREATE TABLE PerformerImage(
  PerformerID INT,
  ImageID     INT, 
  PRIMARY KEY (PerformerID, ImageID),
  FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID),
  FOREIGN KEY (ImageID) REFERENCES Image(ImageID)
) Engine = InnoDB;



-- ===================================================
-- 8. Trigger layer: business rules
-- ===================================================
DELIMITER $$

-- Helper function: minutes already scheduled per festival day
CREATE FUNCTION f_minutes_day(fest INT, d DATE) RETURNS INT DETERMINISTIC
RETURN (
  SELECT COALESCE(SUM(TIMESTAMPDIFF(MINUTE, StartTS, EndTS)), 0)
    FROM Event
   WHERE FestivalID = fest
     AND DATE(StartTS) = d
);$$


CREATE TRIGGER trg_festival
BEFORE INSERT ON Festival
FOR EACH ROW
BEGIN
  IF NEW.ContinentID <> (SELECT cont.ContinentID FROM Festival f INNER JOIN Location l ON l.LocationID = f.LocationID INNER JOIN Address a ON a.AddressID = l.AddressID INNER JOIN City ct ON ct.CityID = a.CityID 
							INNER JOIN Country ctry ON ctry.CountryID = ct.CountryID INNER JOIN Continent cont ON cont.ContinentID = ctry.ContinentID WHERE f.FestivalID = NEW.FestivalID) 
  THEN
  SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Continent and Location misalignment';
  END IF;
END$$
-- Event timing & overlap & daily cap
CREATE TRIGGER trg_event
BEFORE INSERT ON Event
FOR EACH ROW
BEGIN
  IF NEW.EndTS <= NEW.StartTS
     OR TIMESTAMPDIFF(HOUR, NEW.StartTS, NEW.EndTS) > 12 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Event timing invalid (>12h or End<=Start)';
  END IF;
  IF EXISTS (
    SELECT 1 FROM Event e
     WHERE e.StageID = NEW.StageID
       AND NEW.StartTS < e.EndTS
       AND NEW.EndTS   > e.StartTS
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Stage already booked at that time';
  END IF;
  IF f_minutes_day(NEW.FestivalID, DATE(NEW.StartTS))
     + TIMESTAMPDIFF(MINUTE, NEW.StartTS, NEW.EndTS) > 780 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Festival daily limit (13h) exceeded';
  END IF;
END$$

-- PerformanceSlot validation (fixed variable types)
CREATE TRIGGER trg_slot
BEFORE INSERT ON PerformanceSlot
FOR EACH ROW
BEGIN
  DECLARE eStart      DATETIME;
  DECLARE eEnd        DATETIME;
  DECLARE prevEnd     DATETIME;
  DECLARE consecYears INT;
  DECLARE curYear     YEAR;

  SELECT StartTS, EndTS
    INTO eStart, eEnd
    FROM Event
   WHERE EventID = NEW.EventID;

  -- Bounds & duration
  IF NEW.StartTS < eStart
     OR NEW.StartTS >= eEnd
     OR NEW.StartTS + INTERVAL NEW.DurationMin MINUTE > eEnd THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Slot outside event bounds or duration invalid';
  END IF;
  IF NEW.DurationMin < 1 OR NEW.DurationMin > 180 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Slot duration invalid';
  END IF;

  -- Overlap within event
  IF EXISTS (
    SELECT 1 FROM PerformanceSlot s
     WHERE s.EventID = NEW.EventID
       AND NEW.StartTS < s.StartTS + INTERVAL s.DurationMin MINUTE
       AND NEW.StartTS + INTERVAL NEW.DurationMin MINUTE > s.StartTS
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Overlapping slot';
  END IF;	

  -- Gap 5–30 min
  SELECT MAX(s.StartTS + INTERVAL s.DurationMin MINUTE)
    INTO prevEnd
    FROM PerformanceSlot s
   WHERE s.EventID = NEW.EventID
     AND s.StartTS < NEW.StartTS;
  IF prevEnd IS NOT NULL
     AND TIMESTAMPDIFF(MINUTE, prevEnd, NEW.StartTS) NOT BETWEEN 5 AND 30 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Gap between slots must be 5–30 min';
  END IF;

  -- Performer not double-booked
  IF EXISTS (
    SELECT 1 FROM PerformanceSlot s JOIN Event e2 ON s.EventID = e2.EventID
     WHERE s.PerformerID = NEW.PerformerID
       AND NEW.StartTS < s.StartTS + INTERVAL s.DurationMin MINUTE
       AND NEW.StartTS + INTERVAL NEW.DurationMin MINUTE > s.StartTS
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performer double booked';
  END IF;

  -- No >3 consecutive years
  SELECT YEAR(f.StartDate)
    INTO curYear
    FROM Festival f JOIN Event ev ON f.FestivalID = ev.FestivalID
   WHERE ev.EventID = NEW.EventID;

  SELECT COUNT(DISTINCT YEAR(f2.StartDate))
    INTO consecYears
    FROM PerformanceSlot s2
    JOIN Event e3      ON s2.EventID = e3.EventID
    JOIN Festival f2    ON e3.FestivalID = f2.FestivalID
   WHERE s2.PerformerID = NEW.PerformerID
     AND YEAR(f2.StartDate) BETWEEN curYear-3 AND curYear-1;

  IF consecYears >= 3 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Performer >3 consecutive years';
  END IF;
END$$

-- Technician ≤2 slots/day
-- CREATE TRIGGER trg_tech
-- BEFORE INSERT ON Assignment
-- FOR EACH ROW
-- BEGIN
--   DECLARE roleName VARCHAR(20);
--   DECLARE perfDay  DATE;
--   DECLARE c        INT;

--   SELECT r.Name
--     INTO roleName
--     FROM Personnel p JOIN RoleType r ON p.RoleID = r.RoleID
--    WHERE p.PersonID = NEW.PersonID;

--   IF roleName = 'Technician' THEN
--     SELECT DATE(StartTS) INTO perfDay
--       FROM PerformanceSlot
--      WHERE SlotID = NEW.SlotID;

--     SELECT COUNT(*) INTO c
--       FROM Assignment a JOIN PerformanceSlot ps ON a.SlotID = ps.SlotID
--      WHERE a.PersonID = NEW.PersonID
--        AND DATE(ps.StartTS) = perfDay;

--     IF c >= 4 THEN
--       SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'Technician already on 2 slots that day';
--     END IF;
--   END IF;
-- END$$

-- Ticket capacity & generic category quota
CREATE TRIGGER trg_ticket
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
  DECLARE cap     INT;
  DECLARE sold    INT;
  DECLARE catSold INT;
  DECLARE maxPct  DECIMAL(5,2);

  -- Stage capacity
  SELECT s.Capacity INTO cap
    FROM Event e JOIN Stage s ON e.StageID = s.StageID
   WHERE e.EventID = NEW.EventID;

  SELECT COUNT(*) INTO sold
    FROM Ticket
   WHERE EventID = NEW.EventID;
  IF sold >= cap THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Stage capacity full';
  END IF;

  -- Category quota
  SELECT MaxPercent INTO maxPct
    FROM TicketCategory
   WHERE CategoryID = NEW.CategoryID;

  SELECT COUNT(*) INTO catSold
    FROM Ticket
   WHERE EventID = NEW.EventID
     AND CategoryID = NEW.CategoryID;
  IF catSold >= FLOOR(cap * maxPct / 100) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Category quota exceeded';
  END IF;
END$$

-- EAN-13 validation
CREATE TRIGGER trg_ticket_ean
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
  IF NEW.TicketEAN < 1000000000000 OR NEW.TicketEAN > 9999999999999 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'TicketEAN must be a 13-digit EAN-13 code';
  END IF;
END$$

-- Ratings require activated tickets
CREATE TRIGGER trg_rating
BEFORE INSERT ON Rating
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM Ticket
     WHERE TicketEAN = NEW.TicketEAN
       AND Activated = TRUE
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Ticket not activated';
  END IF;
END$$

DELIMITER ;

-- ===================================================
-- 9. Indexes
-- ===================================================
CREATE INDEX idx_ticket_event_method  ON Ticket(EventID, MethodID);
CREATE INDEX idx_assignment_slot_role ON Assignment(SlotID, PersonID);
CREATE INDEX idx_slot_event_seq         ON PerformanceSlot(EventID, SeqNo);
CREATE INDEX idx_ticket_category        ON Ticket(EventID, CategoryID);

-- End of install script
