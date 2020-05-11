--SET @vPathFiles='/home/goldenfox/Documentos/Project_BK/updateDB';
-- ================================== TRIGGERS FOR INSERTING NEW ROWS =============================
-- This triggers will be display when a new row in the table RawData will be insert
use test;


-- Trigger for tables system and sytemType

DELIMITER //
CREATE TRIGGER trig_sys_systype_Ins AFTER INSERT
ON RawData FOR EACH ROW
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
IF (SELECT NEW.systemtype NOT IN (SELECT name FROM systemType))  THEN
	INSERT INTO systemType (name, createdDate, source)
	VALUES (NEW.systemtype, LOCALTIME, @vSource);
END IF;

SET @sysTypeId = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
INSERT INTO system (sysId, navn, sysType, beskrivelse, createdDate, source)
VALUES (NEW.system_id, NEW.navn, @sysTypeId, NEW.beskrivelse, LOCALTIME, @vSource);

 END;//
DELIMITER ;


-- Trigger for tables person and System_Person_Role

DELIMITER //
CREATE TRIGGER trig_person_sysPersRole_Ins AFTER INSERT
ON RawData FOR EACH ROW 
FOLLOWS trig_sys_systype_Ins
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
IF (SELECT NEW.systemeier NOT IN (SELECT name FROM person))  THEN
	INSERT INTO person (name, createdDate, source)
	VALUES (NEW.systemeier, LOCALTIME, @vSource);
END IF;
IF (SELECT NEW.systemkoordinator NOT IN (SELECT name FROM person))  THEN
	INSERT INTO person (name, createdDate, source)
	VALUES (NEW.systemkoordinator, LOCALTIME, @vSource);
END IF;
SET @sysId = (SELECT id FROM system WHERE navn = NEW.navn and sysId = NEW.system_id);
SET @meierRolId = (SELECT rolId FROM role WHERE name = 'systemeier');
SET @meierPersId = (SELECT persId FROM person WHERE name = NEW.systemeier);
INSERT INTO System_Person_Role (persId, sysId, roleId, createdDate, source)
VALUES (@meierPersId, @sysId, @meierRolId, LOCALTIME, @vSource);
SET @koorPersId = (SELECT persId FROM person WHERE name = NEW.systemkoordinator);
SET @koorRolId = (SELECT rolId FROM role WHERE name = 'systemkoordinator');
INSERT INTO System_Person_Role (persId, sysId, roleId, createdDate, source)
VALUES (@koorPersId, @sysId, @koorRolId, LOCALTIME, @vSource);
 END;//
DELIMITER ;


-- Trigger for table System_Network

DELIMITER //
CREATE TRIGGER trig_sys_networks_Ins AFTER INSERT
ON RawData FOR EACH ROW
FOLLOWS trig_sys_systype_Ins
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');

SET @admSoneId = (SELECT id FROM network  WHERE name = 'Adm sone' );
SET @sikkerSoneId = (SELECT id FROM network  WHERE name = 'Sikker sone' );
SET @elevnettId = (SELECT id FROM network  WHERE name = 'Elevnett' );
SET @TUnettId = (SELECT id FROM network  WHERE name = 'TU nett' );

SET @sysId = (SELECT id FROM system WHERE navn = NEW.navn and sysId = NEW.system_id);

INSERT INTO System_Network (idNet, sysId, createdDate, valueN, source)
VALUES (@admSoneId, @sysId , LOCALTIME ,NEW.admsone, @vSource);

INSERT INTO System_Network (idNet, sysId, createdDate, valueN, source)
VALUES (@sikkerSoneId, @sysId , LOCALTIME ,NEW.sikker_sone, @vSource);

INSERT INTO System_Network (idNet, sysId, createdDate, valueN, source)
VALUES (@elevnettId, @sysId , LOCALTIME ,NEW.elevnett, @vSource);

INSERT INTO System_Network (idNet, sysId, createdDate, valueN, source)
VALUES (@TUnettId, @sysId , LOCALTIME ,NEW.tu_nett, @vSource);

 END;//
DELIMITER ;

-- Trigger for table System_Personopplysninger

DELIMITER //
CREATE TRIGGER trig_sys_personopplysninger_Ins AFTER INSERT
ON RawData FOR EACH ROW
FOLLOWS trig_sys_systype_Ins
BEGIN
SET @xvSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysId = (SELECT id FROM system WHERE navn = NEW.navn and sysId = NEW.system_id);

SET @persdataId = (SELECT id FROM person_opplysninger WHERE name = 'persondata' );
INSERT INTO System_Personopplysninger (persOppId, sysId, createdDate, valueN, source)
VALUES (@persdataId, @sysId , LOCALTIME , IF(NEW.personopplysninger = '', 0, CONVERT(NEW.personopplysninger, INT)), @xvSource);

SET @sensDataId = (SELECT id FROM person_opplysninger WHERE name = 'Sensitive persondata' );
INSERT INTO System_Personopplysninger (persOppId, sysId, createdDate, valueN, source)
VALUES (@sensDataId, @sysId , LOCALTIME , IF(NEW.sensitive_personopplysninger = '', 0, CONVERT(NEW.sensitive_personopplysninger, INT)), @xvSource);

 END;//
DELIMITER ;

-- ================================== TRIGGERS FOR UPDATING TABLES ================================
-- This triggers will be display when a row in the table RawData_Update will be insert, to
-- update the original RawData

-- Trigger for tables system and sytemType









