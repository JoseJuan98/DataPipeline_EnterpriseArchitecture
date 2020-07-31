-- ___________________ IMPORTANT TO READ ______________________
-- THIS FILE IS JUST AN ATTEMP OF MAKING A DATA MODEL WITHOUT A NORMALISED MODEL, IT'S NOT USED IN THE FINAL VERSION.

--SET @path_load = "/home/goldenfox/Escritorio/test1.csv";
-- Trigger to create the Relations from System_Personopplysninger

--LINES TERMINATED BY '\n'
-- (id, name, type, owner_id, @datevar, rental_price)
-- set date_made = STR_TO_DATE(@datevar,'%m/%d/%Y');
DELIMITER //
CREATE TRIGGER trig_prop_SysMeier_SysKoord_Ins AFTER INSERT
ON System_Person_Role FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
SET @sysTypeId = (SELECT sysType FROM system WHERE id = NEW.sysId);
IF(@sysTypeId  = @fagId) THEN
SET @sysTypeName = (SELECT name FROM systemType WHERE sysTypeId = @sysTypeId);
SET @sysID = (SELECT sysId FROM system WHERE id = NEW.sysId);
SET @newID = CONCAT( 'SYS_', SUBSTR(@sysTypeName,1, 3),'_',  CONVERT(LPAD(@sysID,5,0), CHAR));
SET @key = (SELECT name FROM role WHERE rolId = NEW.roleId);
SET @persName = (SELECT name FROM person WHERE persId = NEW.persId);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, @key, @persName, LOCALTIME, NEW.isDeleted, NEW.source);
END IF;
 	END;//
DELIMITER ;
--===
DELIMITER //
CREATE TRIGGER trig_rel_SysNet_Ins AFTER INSERT
ON System_Network FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
SET @sysTypeId = (SELECT sysType FROM system WHERE id = NEW.sysId);
IF(@sysTypeId  = @fagId) THEN
SET @sysTypeName = (SELECT name FROM systemType WHERE sysTypeId = @sysTypeId);
SET @systemId = (SELECT sysId FROM system WHERE id=NEW.sysId);
SET @netID = CONCAT("ComNet",CONVERT(LPAD(NEW.idNet,4,0), CHAR));
SET @elID = CONCAT( 'SYS_', SUBSTR(@sysTypeName,1, 3),'_',  CONVERT(LPAD(@systemId,5,0), CHAR));
SET @relID = CONCAT(@netID,'_',@systemId);
SET @key = (SELECT name FROM role WHERE rolId = NEW.roleId);
SET @persName = (SELECT name FROM person WHERE persId = NEW.persId);
INSERT INTO Relation (ID_R, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET, createdDate, isDeleted, source)
VALUES (@relID, 'AssociationRelationship', NULL, NULL,@netID ,@elID, LOCALTIME, NEW.isDeleted, NEW.source);
END IF;
 	END;//
DELIMITER ;
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

select ID, TYPE, NAME, DOCUMENTATION from Element into outfile '/tmp/Sys_Element.csv';

select concat('"',systemtype,'","',system_id,'","',navn,'","',beskrivelse,'","',systemeier,'","',systemkoordinator,'","',admsone,'","',sikker_sone,'","',elevnett,'","',tu_nett,'","',internettviktighet,'","',personopplysninger,'","',sensitive_personopplysninger,'"')
from RawData into outfile '/tmp/test1.csv';


-- Triggers for updating
DELIMITER //
CREATE TRIGGER trig_Update_RawData AFTER INSERT
ON RawData_Update FOR EACH ROW
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
IF (SELECT 1 FROM RawData WHERE (systemtype,system_id) IN (SELECT systemtype,system_id FROM RawData_Update) = 1)  THEN
	IF( (SELECT 1 FROM RawData WHERE ( systemtype = NEW.systemtype AND system_id = NEW.system_id) AND ( navn <> NEW.navn OR  beskrivelse <> NEW.beskrivelse OR systemeier <> NEW.systemeier OR systemkoordinator <> NEW.systemkoordinator OR admsone <> NEW.admsone OR sikker_sone <> NEW.sikker_sone OR tu_nett <> NEW.tu_nett OR personopplysninger <> NEW.personopplysninger OR sensitive_personopplysninger <> NEW.sensitive_personopplysninger)) = 1) THEN
	UPDATE RawData as R
	SET R.navn = NEW.navn ,  R.beskrivelse = NEW.beskrivelse , R.systemeier = NEW.systemeier , R.systemkoordinator = NEW.systemkoordinator , R.admsone = NEW.admsone , R.sikker_sone = NEW.sikker_sone , R.tu_nett = NEW.tu_nett , R.personopplysninger = NEW.personopplysninger , R.sensitive_personopplysninger = NEW.sensitive_personopplysninger
	WHERE R.systemtype = NEW.systemtype AND R.system_id = NEW.system_id;
	END IF;
ELSE
	INSERT IGNORE INTO RawData (system_id, systemtype, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett, tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger, createdDate, source)
	VALUES (NEW.system_id, NEW.systemtype, NEW.navn, NEW.beskrivelse, NEW.systemeier,  NEW.systemkoordinator, NEW.admsone, NEW.sikker_sone, NEW.elevnett, NEW.tu_nett , NEW.internettviktighet, NEW.personopplysninger,  NEW.sensitive_personopplysninger, LOCALTIME, @vSource);
END IF;
 END;//
DELIMITER ;



