-- ========================================= ARCHI MODEL TRIGGERS ===================================
-- Trigger to create the Archi Elements depending on Systems
DELIMITER //
CREATE TRIGGER trig_Elem_SysProp_Ins AFTER INSERT
ON system FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
IF(NEW.sysType = @fagId) THEN
SET @sysType = (SELECT name FROM systemType WHERE sysTypeId=NEW.sysType);
SET @newID = CONCAT( 'SYS_', SUBSTR(@sysType,1, 3),'_',  CONVERT(LPAD(NEW.sysId,5,0), CHAR) );
INSERT INTO Element (sysId, ID, TYPE, NAME, DOCUMENTATION, createdDate, source)
VALUES(NEW.id, @newID, 'ApplicationComponent', NEW.navn, NEW.beskrivelse, LOCALTIME, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Kilde', 'Systemoversikten', LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Systemtype', @sysType, LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Opprettet', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Sistoppdatert', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
END IF;
 	END;//
DELIMITER ;
-- Trigger to create the Properties Systemeier and Systemkoordinator from a System
DELIMITER //
CREATE TRIGGER trig_prop_SysMeier_SysKoord_Ins AFTER INSERT
ON System_Person_Role FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
SET @sysTypeId = (SELECT sysType FROM system WHERE id = NEW.sysId);
IF(@sysTypeId  = @fagId) THEN
SET @sysTypeName = (SELECT name FROM systemType WHERE sysTypeId = @sysTypeId);
SET @systemId = (SELECT sysId FROM system WHERE id=NEW.sysId);
SET @newID = CONCAT( 'SYS_', SUBSTR(@sysTypeName,1, 3),'_',  CONVERT(LPAD(@systemId,5,0), CHAR));
SET @key = (SELECT name FROM role WHERE rolId = NEW.roleId);
SET @persName = (SELECT name FROM person WHERE persId = NEW.persId);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, @key, @persName, LOCALTIME, NEW.isDeleted, NEW.source);
END IF;
 	END;//
DELIMITER ;

-- Trigger to create the Relations from System_Network
DELIMITER //
CREATE TRIGGER trig_rel_SysNet_Ins AFTER INSERT
ON System_Network FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
SET @sysTypeId = (SELECT sysType FROM system WHERE id = NEW.sysId);
IF(@sysTypeId  = @fagId) THEN
	IF(NEW.valueN = 1) THEN
	SET @sysTypeName = (SELECT name FROM systemType WHERE sysTypeId = @sysTypeId);
	SET @systemId = (SELECT sysId FROM system WHERE id=NEW.sysId);
	SET @netID = CONCAT("ComNet",CONVERT(LPAD(NEW.idNet,4,0), CHAR));
	SET @elID = CONCAT( 'SYS_', SUBSTR(@sysTypeName,1, 3),'_',  CONVERT(LPAD(@systemId,5,0), CHAR));
	SET @relID = CONCAT(@netID,'_',@elID);
	INSERT INTO Relation (ID_R, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET, createdDate, isDeleted, sourceModel)
	VALUES (@relID, 'AssociationRelationship', NULL, NULL,@netID ,@elID, LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Kilde', 'Systemoversikten', LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Opprettet', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Sistoppdatert', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
	END IF;
END IF;
 	END;//
DELIMITER ;

-- Trigger to create the Relations from System_Personopplysninger
DELIMITER //
CREATE TRIGGER trig_rel_SysPersopp_Ins AFTER INSERT
ON System_Personopplysninger FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
SET @sysTypeId = (SELECT sysType FROM system WHERE id = NEW.sysId);
IF(@sysTypeId  = @fagId) THEN
	IF(NEW.valueN = 1) THEN
	SET @sysTypeName = (SELECT name FROM systemType WHERE sysTypeId = @sysTypeId);
	SET @systemId = (SELECT sysId FROM system WHERE id=NEW.sysId);
	SET @persoppID = CONCAT("Constr",CONVERT(LPAD(NEW.persOppId,4,0), CHAR));
	SET @elID = CONCAT( 'SYS_', SUBSTR(@sysTypeName,1, 3),'_',  CONVERT(LPAD(@systemId,5,0), CHAR));
	SET @relID = CONCAT(@persoppID,'_',@elID);
	INSERT INTO Relation (ID_R, TYPE, NAME, DOCUMENTATION, SOURCE, TARGET, createdDate, isDeleted, sourceModel)
	VALUES (@relID, 'AssociationRelationship', NULL, NULL,@persoppID ,@elID, LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Kilde', 'Systemoversikten', LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Opprettet', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
	INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
	VALUES (@relID, 'Sistoppdatert', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
	END IF;
END IF;
 	END;//
DELIMITER ;

