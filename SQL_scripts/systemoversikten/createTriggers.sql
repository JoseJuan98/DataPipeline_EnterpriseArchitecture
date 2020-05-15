--SET @vPathFiles='/home/goldenfox/Documentos/Project_BK/updateDB';
-- ================================== TRIGGERS FOR INSERTING NEW ROWS =============================
-- This triggers will be display when a new row in the table RawData will be insert
--use test;


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
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = NEW.system_id);
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

SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = NEW.system_id);

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
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = NEW.system_id);

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

-- Trigger for table system
DELIMITER //
CREATE TRIGGER trig_sys_Update AFTER UPDATE
ON RawData FOR EACH ROW
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = OLD.systemtype);

UPDATE system as s
SET navn = NEW.navn, beskrivelse = NEW.beskrivelse, lastModified = LOCALTIME, isDeleted = NEW.isDeleted, source = @vSource
WHERE (s.sysType = @sysType AND s.sysId = OLD.system_id);

 END;//
DELIMITER ;

-- Triger to update table System_Person_Role for roles systemkoordinator and systemeier
DELIMITER //
CREATE TRIGGER trig_sysPersRole_Update AFTER UPDATE
ON RawData FOR EACH ROW
FOLLOWS trig_sys_Update
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = OLD.system_id);
SET @meierRolId = (SELECT rolId FROM role WHERE name = 'systemeier');
IF (OLD.systemeier <> NEW.systemeier) THEN
	IF (SELECT NEW.systemeier NOT IN (SELECT name FROM person))  THEN
	INSERT INTO person (name, createdDate, source)
	VALUES (NEW.systemeier, LOCALTIME, @vSource);
	END IF;
	SET @meierPersIdOld = (SELECT persId FROM person WHERE name = OLD.systemeier);
	UPDATE System_Person_Role as SR
	SET lastModified = LOCALTIME, isDeleted=1
	WHERE SR.persId = @meierPersIdOld AND SR.sysId = @sysId AND SR.roleId = @meierRolId;
	SET @meierPersIdNew = (SELECT persId FROM person WHERE name = NEW.systemeier);
	INSERT INTO System_Person_Role (persId, sysId, roleId, createdDate, source, isDeleted)
	VALUES (@meierPersIdNew, @sysId, @meierRolId, LOCALTIME, @vSource, 0);
END IF;
IF(NEW.isDeleted = 1) THEN
	SET @meierPersIdOld1 = (SELECT persId FROM person WHERE name = OLD.systemeier);
	UPDATE System_Person_Role as SR
	SET lastModified = LOCALTIME, isDeleted=1
	WHERE SR.persId = @meierPersIdOld1 AND SR.sysId = @sysId AND SR.roleId = @meierRolId;
END IF;
SET @koorRolId = (SELECT rolId FROM role WHERE name = 'systemkoordinator');
IF(OLD.systemkoordinator <> NEW.systemkoordinator) THEN
	IF (SELECT NEW.systemkoordinator NOT IN (SELECT name FROM person))  THEN
	INSERT INTO person (name, createdDate, source)
	VALUES (NEW.systemkoordinator, LOCALTIME, @vSource);
	END IF;
	SET @koorPersIdOLD = (SELECT persId FROM person WHERE name = OLD.systemkoordinator);
	UPDATE System_Person_Role as SR
	SET lastModified = LOCALTIME, isDeleted=1
	WHERE SR.persId = @koorPersIdOLD AND SR.sysId = @sysId AND SR.roleId = @koorRolId;
	SET @koorPersIdNEW = (SELECT persId FROM person WHERE name = NEW.systemkoordinator);
	INSERT INTO System_Person_Role (persId, sysId, roleId, createdDate, source, isDeleted)
	VALUES (@koorPersIdNEW, @sysId, @koorRolId, LOCALTIME, @vSource, 0);
END IF;
IF(NEW.isDeleted = 1) THEN
	SET @koorPersIdOLD1 = (SELECT persId FROM person WHERE name = OLD.systemkoordinator);
	UPDATE System_Person_Role as SR
	SET lastModified = LOCALTIME, isDeleted=1
	WHERE SR.persId = @koorPersIdOLD1 AND SR.sysId = @sysId AND SR.roleId = @koorRolId;
END IF;
 END;//
DELIMITER ;


-- Triggers for updating the System_Networks
DELIMITER //
CREATE TRIGGER trig_SysNetworks_Update AFTER UPDATE
ON RawData FOR EACH ROW
FOLLOWS trig_sys_Update
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = OLD.system_id);
IF(OLD.admsone <> NEW.admsone) THEN
SET @admSoneId = (SELECT id FROM network  WHERE name = 'Adm sone' );
UPDATE System_Network as s
SET lastModified=LOCALTIME, valueN=NEW.admsone, source=@vSource, isDeleted=NEW.isDeleted
WHERE (idNet=@admSoneId AND sysId=@sysId);
END IF;
IF(OLD.sikker_sone <> NEW.sikker_sone) THEN
SET @sikkerSoneId = (SELECT id FROM network  WHERE name = 'Sikker sone' );
UPDATE System_Network as s
SET lastModified=LOCALTIME, valueN=NEW.sikker_sone, source=@vSource, isDeleted=NEW.isDeleted
WHERE (idNet=@sikkerSoneId AND sysId=@sysId);
END IF;
IF(OLD.elevnett <> NEW.elevnett) THEN
SET @elevnettId = (SELECT id FROM network  WHERE name = 'Elevnett' );
UPDATE System_Network as s
SET lastModified=LOCALTIME, valueN=NEW.elevnett, source=@vSource, isDeleted=NEW.isDeleted
WHERE (idNet=@elevnettId AND sysId=@sysId);
END IF;
IF(OLD.tu_nett <> NEW.tu_nett) THEN
SET @TUnettId = (SELECT id FROM network  WHERE name = 'TU nett' );
UPDATE System_Network as s
SET lastModified=LOCALTIME, valueN=NEW.tu_nett, source=@vSource, isDeleted=NEW.isDeleted
WHERE (idNet=@TUnettId AND sysId=@sysId);
END IF;
IF(NEW.isDeleted = 1) THEN
UPDATE System_Network as s
SET lastModified=LOCALTIME, isDeleted=NEW.isDeleted
WHERE sysId=@sysId;
END IF;
 END;//
DELIMITER ;


-- Triggers for updating the System_Personoppplysinger
DELIMITER //
CREATE TRIGGER trig_SysPersonopplysninger_Update AFTER UPDATE
ON RawData FOR EACH ROW
FOLLOWS trig_sys_Update
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
SET @sysId = (SELECT id FROM system WHERE sysType = @sysType AND sysId = OLD.system_id);
IF(OLD.personopplysninger <> NEW.personopplysninger ) THEN
SET @persdataId = (SELECT id FROM person_opplysninger WHERE name = 'persondata' );
UPDATE System_Personopplysninger
SET lastModified=LOCALTIME, valueN=NEW.personopplysninger, source=@vSource, isDeleted=NEW.isDeleted
WHERE (persOppId=@persdataId AND sysId=@sysId);
END IF;
IF(OLD.sensitive_personopplysninger <> NEW.sensitive_personopplysninger ) THEN
SET @sensDataId = (SELECT id FROM person_opplysninger WHERE name = 'Sensitive persondata' );
UPDATE System_Personopplysninger
SET lastModified=LOCALTIME, valueN=NEW.sensitive_personopplysninger, source=@vSource, isDeleted=NEW.isDeleted
WHERE (persOppId=@sensDataId AND sysId=@sysId);
END IF;
IF(NEW.isDeleted = 1) THEN
UPDATE System_Personopplysninger as s
SET lastModified=LOCALTIME, isDeleted=NEW.isDeleted
WHERE sysId=@sysId;
END IF;
 END;//
DELIMITER ;