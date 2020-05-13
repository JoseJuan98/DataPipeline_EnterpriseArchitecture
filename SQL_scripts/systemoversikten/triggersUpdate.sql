DELIMITER //
CREATE TRIGGER trig_sys_systype_Update AFTER UPDATE
ON RawData FOR EACH ROW
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'Systemoversikten');
SET @sysType = (SELECT sysTypeId FROM systemType WHERE name = OLD.systemtype);

UPDATE system as s
SET navn = NEW.navn, beskrivelse = NEW.beskrivelse, lastModified = LOCALTIME, isDeleted = NEW.isDeleted, source = @vSource
WHERE (s.sysType = @sysType AND s.sysId = OLD.system_id);

 END;//
DELIMITER ;

drop trigger trig_sys_systype_Update;