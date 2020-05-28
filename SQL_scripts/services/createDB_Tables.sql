-- ========================= MANUAL TABLES ===========================================
Use test;

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

-- ===============================  TABLES ====================================




-- ======================= AUXILIAR TABLES  =======================================

CREATE TABLE IF NOT EXISTS RawData (

	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY (systemtype,system_id),
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
) DEFAULT CHARSET=utf8;

--AUXILIAR TABLE TO HELP FOR UPDATES

CREATE TABLE IF NOT EXISTS RawData_Update (	

	createdDate DATETIME DEFAULT LOCALTIME,
	lastModified DATETIME DEFAULT LOCALTIME,
	isDeleted INT(1) DEFAULT 0,
	source INT(11) DEFAULT 1,
	PRIMARY KEY (systemtype,system_id),
	FOREIGN KEY ( source ) REFERENCES source ( srcId )
) DEFAULT CHARSET=utf8;

--sysType_Id varchar (14),




