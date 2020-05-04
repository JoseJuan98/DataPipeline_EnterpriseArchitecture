--SET @vPathFiles='/home/goldenfox/Documentos/Project_BK/updateDB';

-- ========================= MANUAL TABLES ===========================================

--drop trigger trig_sys_systype;
--drop table system, systemType, source;


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
( 'Difi', LOCALTIME );

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
SET @vSource = (SELECT srcId FROM source WHERE name = 'systemoversikten');
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
DELIMITER //
CREATE TRIGGER trig_sys_systype AFTER UPDATE
ON RawData FOR EACH ROW
BEGIN
IF (SELECT NEW.systemtype NOT IN (SELECT name FROM systemType))  THEN
	INSERT INTO systemType (name, createdDate, lastModified, isDeleted)
	VALUES (NEW.systemtype, LOCALTIME, LOCALTIME, 0);
END IF;

SET @sysTypeId = (SELECT sysTypeId FROM systemType WHERE name = NEW.systemtype);
INSERT INTO system (sysId, navn, sysType, beskrivelse,createdDate, lastModified, isDeleted)
VALUES (NEW.system_id, NEW.navn, @sysTypeId, NEW.beskrivelse, LOCALTIME, LOCALTIME, 0);

 END;//
DELIMITER ;

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
FOLLOWS trig_sys_systype
BEGIN
SET @vSource = (SELECT srcId FROM source WHERE name = 'systemoversikten');
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



CREATE TABLE personpplysninger (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),

);


CREATE TABLE network (
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11),
	FOREIGN KEY ( source ) REFERENCES source ( srcId ),

);
