

DELIMITER //
CREATE TRIGGER trig_sys_systype_Update AFTER UPDATE
ON RawData FOR EACH ROW
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
IF (SELECT NEW.systemtype NOT IN (SELECT name FROM systemType))  THEN
	INSERT INTO systemType (name, createdDate, source)
	VALUES (NEW.systemtype, LOCALTIME, @vSource);
END IF;

SET @sysTypeId = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);

INSERT INTO system (sysId, navn, sysType, beskrivelse, lastModified, source)
VALUES (NEW.system_id, NEW.navn, @sysTypeId, NEW.beskrivelse, LOCALTIME, @vSource);

UPDATE system as s
SET navn = NEW.navn, beskrivelse = NEW.beskrivelse, lastModified = LOCALTIME
WHERE s.systemtype = OLD.systemtype AND OLD.system_id = s.sys_id);

 END;//
DELIMITER ;

drop trigger trig_sys_systype_Update;