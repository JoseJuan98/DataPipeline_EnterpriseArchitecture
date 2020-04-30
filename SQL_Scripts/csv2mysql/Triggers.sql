--SET @path_load = "/home/goldenfox/Escritorio/test1.csv";

--LINES TERMINATED BY '\n'
-- (id, name, type, owner_id, @datevar, rental_price)
-- set date_made = STR_TO_DATE(@datevar,'%m/%d/%Y');

--Use test;
delete from RawData;

CREATE TABLE Element (
	idEl int AUTO_INCREMENT PRIMARY KEY,
	ID VARCHAR(255),
	TYPE VARCHAR(255),
	NAME VARCHAR(255),
	DOCUMENTATION TEXT
);

--PRIMARY KEY (ID),
--UNIQUE KEY uniqueID (ID)

--ALTER TABLE Andre_Elements
--ADD UNIQUE KEY uniSID (sid);

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

INSERT INTO Element (idEl, ID, TYPE, NAME, DOCUMENTATION)
VALUES(NEW.id, @newID, @vtype, NEW.navn, NEW.beskrivelse);
 	END;//
DELIMITER ;

--delete from RawData;

--select count(*) from RawData;
--select count(*) from Element;

--drop trigger trig_andre_elem;
-- =========================================================================================
CREATE TABLE Relation (
	ID VARCHAR(255) PRIMARY KEY, 
	TYPE VARCHAR(255), 
	NAME VARCHAR(255),
	DOCUMENTATION TEXT,
	SOURCE INT,
	TARGET INT,
	Foreign Key ( SOURCE ) References Andre_Elements(id)
	ON UPDATE CASCADE ON DELETE CASCADE,
	Foreign Key ( TARGET ) References Element(idEl)
	ON UPDATE CASCADE ON DELETE CASCADE
)Engine="InnoDB";



DELIMITER //
CREATE TRIGGER trig_Rel_adm AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.admsone=1 LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'Adm sone');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'Adm sone');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_Rel_sikker AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.sikker_sone=1 LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'Sikker sone');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'Sikker sone');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_Rel_elevnett AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.elevnett=1 LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'Elevnett');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'Elevnett');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_Rel_TUnett AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.tu_nett=1 LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'TU nett');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'TU nett');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_Rel_Persondata AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.personopplysninger='1' LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'Persondata');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'Persondata');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_Rel_sensitivePersDat AFTER INSERT
ON Element FOR EACH ROW
BEGIN

	IF ((SELECT 1 FROM RawData as RD WHERE CONCAT( 'SYS_', SUBSTR(RD.systemtype,1, 3),'_',CONVERT(LPAD(RD.system_id,5,0), CHAR)) = NEW.ID AND RD.sensitive_personopplysninger='1' LIMIT 1) = 1)  THEN
	SET @vid = (SELECT id FROM Andre_Elements WHERE name = 'Sensitive persondata');
	SET @vsid = (SELECT sid FROM Andre_Elements WHERE name = 'Sensitive persondata');      

	INSERT INTO Relation (ID, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET)
	VALUES (CONCAT(@vsid,'_',NEW.ID), 'AssociationRelationship', null, null, @vid, NEW.idEl);
	END IF;
 END;//
DELIMITER ;

--select LOWER(REPLACE(name, ' ','_')) from Andre_Elements;

--select COLUMN_NAME from information_schema.columns  
--where table_schema = 'test'     
--and table_name = 'RawData';
-- =========================================================================================

--CREATE TABLE Property (
--	idProp INT(11) PRIMARY KEY AUTO_INCREMENT,
--	KEY_P VARCHAR(255)
--);

--INSERT INTO Property (KEY_P)
--VALUES ('systemeier'),('systemkoordinator'),('internettviktighet');

CREATE TABLE Property (
	ID INT(11),
	KEY_P VARCHAR(255),
	VALUE_P VARCHAR(255),
	PRIMARY KEY (ID, KEY_P),
	Foreign Key ( ID ) References Element(idEl)
	ON UPDATE CASCADE ON DELETE CASCADE
);

LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/RawData.csv" REPLACE INTO TABLE RawData
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett,tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger);


INSERT INTO Property (ID, KEY_P, VALUE_P)
(SELECT e.idEl, 'systemeier', RD.systemeier
FROM Element as e JOIN RawData as RD
ON (RD.id = e.idEl)
WHERE RD.systemeier IS NOT null)
UNION
(SELECT e.idEl, 'systemkoordinator', RD.systemkoordinator
FROM Element as e JOIN RawData as RD
ON (RD.id = e.idEl)
WHERE RD.systemkoordinator IS NOT null)
UNION
(SELECT e.idEl, 'internettviktighet', RD.internettviktighet
FROM Element as e JOIN RawData as RD
ON (RD.id = e.idEl)
WHERE RD.internettviktighet IS NOT null);

-- ================= We have to add the correct format
select concat('"',ID,'"'),concat('"',TYPE,'"'),concat('"',NAME,'"'),concat('"',DOCUMENTATION,'"') from Element into outfile '/tmp/Element.csv';
select * from Relation into outfile '/tmp/Relation.csv';
select * from Property into outfile '/tmp/Property.csv';

sudo mv /tmp/Property.csv /home/goldenfox/Escritorio/
sudo mv /tmp/Element.csv /home/goldenfox/Escritorio/
sudo mv /tmp/Relation.csv /home/goldenfox/Escritorio/













