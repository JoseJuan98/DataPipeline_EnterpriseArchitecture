DELIMITER //
CREATE TRIGGER trig_elem_Ins AFTER INSERT
ON system FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
IF(NEW.sysType = @fagId) THEN
SET @sysType = (SELECT name FROM systemType WHERE sysTypeId=NEW.sysType);
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @newID = CONCAT( 'SYS_', SUBSTR(@sysType,1, 3),'_',  CONVERT(LPAD(NEW.id,5,0), CHAR) );
INSERT INTO Element (sysId, ID, TYPE, NAME, DOCUMENTATION, createdDate, source)
VALUES(NEW.id, @newID, 'ApplicationComponent', NEW.navn, NEW.beskrivelse, LOCALTIME, @vSource);
END IF;
 	END;//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trig_properties_Ins AFTER INSERT
FOLLOWS trig_elem_Ins
ON system FOR EACH ROW
BEGIN
SET @fagId = (SELECT sysTypeId FROM systemType WHERE name = 'Fagsystem');
IF(NEW.sysType = @fagId) THEN
SET @sysType = (SELECT name FROM systemType WHERE sysTypeId=NEW.sysType);
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @newID = CONCAT( 'SYS_', SUBSTR(@sysType,1, 3),'_',  CONVERT(LPAD(NEW.id,5,0), CHAR) );
INSERT INTO Element (sysId, ID, TYPE, NAME, DOCUMENTATION, createdDate, source)
VALUES(NEW.id, @newID, 'ApplicationComponent', NEW.navn, NEW.beskrivelse, LOCALTIME, @vSource);
END IF;
 	END;//
DELIMITER ;


