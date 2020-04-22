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

CASE NEW.systemtype
	WHEN 'Fagsystem' THEN SET @vtype = 'ApplicationComponent';
	WHEN 'Infrastruktur' THEN SET @vtype = 'Artifact';
	WHEN 'Program' THEN SET @vtype = 'SystemSoftware';
	ELSE SET @vtype = 'UNKNOWN';
END CASE;

INSERT INTO Element (ID, TYPE, NAME, DOCUMENTATION)
VALUES( @newID, @vtype, NEW.navn, NEW.beskrivelse);
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
	ID VARCHAR(255) PRIMARY KEY, 
	TYPE VARCHAR(255), 
	NAME VARCHAR(255),
	DOCUMENTATION TEXT,
	SOURCE VARCHAR(255),
	TARGET VARCHAR(255),
	Foreign Key ( SOURCE ) References Element(ID),
	Foreign Key ( TARGET ) References Andre_Elements(sid)
)Engine="InnoDB";

DELIMITER //
CREATE TRIGGER trig_elem AFTER INSERT
ON RawData FOR EACH ROW
BEGIN
set @newID = CONCAT( 'SYS_', SUBSTR(NEW.systemtype,1, 3),'_',  CONVERT(LPAD(NEW.system_id,5,0), CHAR) );

INSERT INTO Element (ID, TYPE, NAME, DOCUMENTATION)
VALUES( @newID, 'AssociationRelationship', NEW.navn, NEW.beskrivelse);
 	END;//
DELIMITER ;


select LOWER(REPLACE(name, ' ','_')) from Andre_Elements;

select COLUMN_NAME from information_schema.columns  
where table_schema = 'test'     
and table_name = 'RawData';


CREATE TABLE Property (
	IDp VARCHAR(255),
	KEY VARCHAR(255),
	VALUEP VARCHAR(255),
	PRIMARY KEY (IDp, KEY),
	FOREIGN KEY (IDp) REFERENCES Element(ID)
	ON UPDATE CASCADE ON DELETE CASCADE
);




















