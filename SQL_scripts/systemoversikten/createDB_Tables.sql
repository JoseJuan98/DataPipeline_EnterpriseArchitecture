-- ========================= MANUAL TABLES ===========================================

CREATE DATABASE test;

use test;

CREATE TABLE source (
	srcId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0
);

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

-- =============================== SYSTEM TABLES ====================================


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


-- ============================== PERSON TABLES ========================================

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

-- =========================== CAPABILITIES TABLES ========================================

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

-- ======================= AUXILIAR TABLES  =======================================

CREATE TABLE IF NOT EXISTS RawData (
	systemtype varchar(255),
	system_id int(11),
	navn varchar(255),
	beskrivelse text,
	systemeier varchar(255),
	systemkoordinator varchar(255),
	admsone int,
	sikker_sone int,
	elevnett int,
	tu_nett int,
	internettviktighet varchar(255),
	personopplysninger varchar(255),
	sensitive_personopplysninger varchar(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY (systemtype,system_id),
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
) DEFAULT CHARSET=utf8;

--AUXILIAR TABLE TO HELP FOR UPDATES

CREATE TABLE IF NOT EXISTS RawData_Update (	
	systemtype varchar(255),
	system_id int(11),
	navn varchar(255),
	beskrivelse text,
	systemeier varchar(255),
	systemkoordinator varchar(255),
	admsone int,
	sikker_sone int,
	elevnett int,
	tu_nett int,
	internettviktighet varchar(255),
	personopplysninger varchar(255),
	sensitive_personopplysninger varchar(255),
	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY (systemtype,system_id),
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
) DEFAULT CHARSET=utf8;

--sysType_Id varchar (14),




