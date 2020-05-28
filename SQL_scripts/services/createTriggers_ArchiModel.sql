-- ========================================= ARCHI MODEL TRIGGERS ===================================
-- ==================================== TRIGGERS FOR INSERTING NEW ROWS =============================
-- This triggers will be display when a new row in the table RawData will be insert

-- Trigger to insert the Archi Elements created before the rest by hand
DELIMITER //
CREATE TRIGGER trig_ElemFromNets_Ins AFTER INSERT
ON network FOR EACH ROW
BEGIN
SET @newID = CONCAT("ComNet",CONVERT(LPAD(NEW.id,4,0), CHAR));
INSERT INTO Element (ID, TYPE, NAME, DOCUMENTATION, createdDate, source)
VALUES(@newID, 'CommunicationNetwork', NEW.name, NEW.documentation, LOCALTIME, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Kilde', 'Manuelt nettverk', LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Opprettet', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Sistoppdatert', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
 	END;//
DELIMITER ;
DELIMITER //
CREATE TRIGGER trig_ElemFrompPersOpp_Ins AFTER INSERT
ON person_opplysninger FOR EACH ROW
BEGIN
SET @newID = CONCAT("Constr",CONVERT(LPAD(NEW.id,4,0), CHAR));
INSERT INTO Element (ID, TYPE, NAME, DOCUMENTATION, createdDate, source)
VALUES(@newID, 'Constraint', NEW.name, NEW.documentation, LOCALTIME, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Kilde', 'Manuelt personopplysninger', LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Opprettet', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
INSERT INTO Property (ID_P, KEY_P, VALUE_P, createdDate, isDeleted, source)
VALUES (@newID, 'Sistoppdatert', LOCALTIME, LOCALTIME, NEW.isDeleted, NEW.source);
 	END;//
DELIMITER ;
-- Trigger to create the Archi Elements depending on Systems

 	END;//
DELIMITER ;
