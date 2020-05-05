--SET @vPathFiles='/home/goldenfox/Documentos/Project_BK/updateDB';

-- ========================= MANUAL TABLES ===========================================

--drop trigger trig_sys_systype;
--drop table system, systemType, source;

use test;

CREATE TABLE source (
	srcId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0
);

INSERT INTO source ( name, createdDate )
VALUES ('unknown source', LOCALTIME),
( 'Systemoversikten', LOCALTIME ),
( 'Fellesdata', LOCALTIME ),
( 'Manuelt nettverk', LOCALTIME ),
( 'Manuelt rolle', LOCALTIME ),
( 'Difi', LOCALTIME ),
( 'Manuelt personopplysninger', LOCALTIME);

CREATE TABLE role (
	rolId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(255),
	beskri VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
);


INSERT INTO role ( name, source )
VALUES 
('systemeier', (SELECT  srcId FROM source where name = 'Manuelt rolle')),
('systemkoordinator',(SELECT srcId FROM source where name = 'Manuelt rolle'));

CREATE TABLE person_opplysninger (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255),
	documentation VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
);

INSERT INTO person_opplysninger (name, createdDate, source)
VALUES 
('persondata', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt personopplysninger')),
('Sensitive persondata', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt personopplysninger'));

CREATE TABLE network (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255),
	documentation VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
);

INSERT INTO network (name, createdDate, source)
VALUES 
('Adm sone', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('Sikker sone', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('Elevnett', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('TU nett', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk'));

-- ==================================== SYSTEM ============================


CREATE TABLE systemType (
	sysTypeId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
);

CREATE TABLE system (
	id INT(11) NOT NULL AUTO_INCREMENT,
	sysId INT(11),
	navn VARCHAR(255),
	sysType INT,
	beskrivelse TEXT,
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),
	PRIMARY KEY (id),
	FOREIGN KEY (sysType) REFERENCES systemType (sysTypeId)
);

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

--TODO UPDATE
--DELIMITER //
--CREATE TRIGGER trig_sys_systype_Update AFTER UPDATE
--ON RawData FOR EACH ROW
--BEGIN
--IF (SELECT NEW.systemtype NOT IN (SELECT name FROM systemType))  THEN
--	INSERT INTO systemType (name, createdDate, lastModified, isDeleted)
--	VALUES (NEW.systemtype, LOCALTIME, LOCALTIME, 0);
--END IF;
--
--SET @sysTypeId = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
--UPDATE system 
--SET 
--WHERE navn = NEW.navn AND sysId = NEW.system_id;
--
--(sysId, navn, sysType, beskrivelse, lastModified, isDeleted)
--VALUES (NEW.system_id, NEW.navn, @sysTypeId, NEW.beskrivelse, LOCALTIME, 0);
--
-- END;//
--DELIMITER ;

-- ======================================================================

CREATE TABLE person (
	persId INT(11) PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11),
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
);

CREATE TABLE System_Person_Role (
	persId INT(11),
	sysId INT(11),
	roleId INT(11),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11),
	PRIMARY KEY ( persId, sysId, roleId ),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),
	FOREIGN KEY ( persId ) REFERENCES person ( persId ),
	FOREIGN KEY ( sysId ) REFERENCES system ( id ),
	FOREIGN KEY ( roleId ) REFERENCES role ( rolId )
);

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

-- =========================== Capabilities ========================================

CREATE TABLE System_Network (
	idNet INT(11),
	sysId INT(11),
	valueN INT(1),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY ( idNet, sysId ),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),
	FOREIGN KEY ( idNet ) REFERENCES network ( id ),
	FOREIGN KEY ( sysId ) REFERENCES system ( id )
);


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

CREATE TABLE System_Personopplysninger (
	persOppId INT(11),
	sysId INT(11),
	valueN INT(1),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY ( persOppId, sysId ),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),
	FOREIGN KEY ( persOppId ) REFERENCES person_opplysninger ( id ),
	FOREIGN KEY ( sysId ) REFERENCES system ( id )
);

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




