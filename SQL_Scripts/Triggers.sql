SET @path_load = "/home/goldenfox/Escritorio/test1.csv";

--LINES TERMINATED BY '\n'
-- (id, name, type, owner_id, @datevar, rental_price)
-- set date_made = STR_TO_DATE(@datevar,'%m/%d/%Y');


CREATE TABLE aux_sys (
	sysId INT PRIMARY KEY,
	sysType VARCHAR(20),
	navn VARCHAR(80)
);

LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/test2.csv" INTO TABLE test.aux_sys
FIELDS TERMINATED BY ','
LINES TERMINATED BY ';'
IGNORE 2 LINES
(sysType, sysID, navn);

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


DELIMITER //
CREATE TRIGGER elements_ins AFTER INSERT ON RawData
  FOR EACH ROW
    BEGIN
      IF ((SELECT 1 FROM post WHERE userId = OLD.userId LIMIT 1) <> 1) THEN
        DELETE FROM user_p WHERE userId = OLD.userId;
      END IF;
    END//
DELIMITER ;

INSERT INTO andre_elem (andId, type, name)
VALUES('works', systemtype ,'test1');

Use test;

CREATE TABLE Element (
	ID VARCHAR(255) PRIMARY KEY,
	TYPE VARCHAR(255),
	NAME VARCHAR(255)
);


DELIMITER //

CREATE TRIGGER trig_andre_elem AFTER INSERT
ON RawData FOR EACH ROW
BEGIN
INSERT INTO andre_elem (type, name)
VALUES( systemtype ,'test1');
 	END;//

DELIMITER ;


LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/RawData.csv" REPLACE INTO TABLE RawData
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett,tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger);

























