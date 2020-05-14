DELIMITER //
CREATE TRIGGER trig_person_sysPersRole_Update AFTER UPDATE
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