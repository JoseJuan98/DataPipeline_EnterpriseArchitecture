DELIMITER //
CREATE TRIGGER trig_elem_Ins AFTER INSERT
ON system FOR EACH ROW
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
