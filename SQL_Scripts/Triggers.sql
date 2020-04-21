--SET @path_load = "/home/goldenfox/Escritorio/test1.csv";

--LINES TERMINATED BY '\n'
-- (id, name, type, owner_id, @datevar, rental_price)
-- set date_made = STR_TO_DATE(@datevar,'%m/%d/%Y');

CREATE TABLE andre_elem (
	andId INT(11) AUTO_INCREMENT PRIMARY KEY,
	type VARCHAR(255),
	name VARCHAR(20)
);


LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/AndreElem.csv" INTO TABLE test.andre_elem
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 2 LINES
(andId, type, name);

CREATE TABLE Element (
	ID VARCHAR(255) PRIMARY KEY,
	TYPE VARCHAR(255),
	NAME VARCHAR(255),
	DOCUMENTATION TEXT
);


DELIMITER //
CREATE TRIGGER trig_elem AFTER INSERT
ON RawData FOR EACH ROW
BEGIN
set @newID = CONCAT( 'SYS_', SUBSTR(NEW.systemtype,1, 3),'_',  CONVERT(LPAD(NEW.system_id,5,0), CHAR) );

INSERT INTO Element (ID, TYPE, NAME, DOCUMENTATION)
VALUES( @newID, 'ApplicationComponent', NEW.navn, NEW.beskrivelse);
 	END;//
DELIMITER ;

LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/RawData.csv" REPLACE INTO TABLE RawData
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett,tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger);

select count(*) from RawData;
drop trigger trig_andre_elem;

CREATE TABLE Relation (
	ID VARCHAR(255) PRIMARY KEY, --"Constr0001_SYS_Fag_00290" andre_elem.name_Element.ID
	TYPE VARCHAR(255), --"AssociationRelationship"
	NAME VARCHAR(255),
	DOCUMENTATION TEXT,
	SOURCE INT(11)
	TARGET VARCHAR(255),
	FOREIGN KEY TARGET REFERENCES Element (ID)
	ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY SOURCE REFERENCES andre_element (ID)
	ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Property (
	ID VARCHAR(255),
	KEY VARCHAR(255),
	VALUE VARCHAR(255),
	PRIMARY KEY (ID, KEY),
	FOREIGN KEY ID REFERENCES Element (ID)
	ON UPDATE CASCADE ON DELETE CASCADE
);




















