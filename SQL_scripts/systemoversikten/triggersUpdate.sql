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

