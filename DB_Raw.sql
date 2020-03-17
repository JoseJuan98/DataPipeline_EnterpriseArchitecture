/* JJ - 17 - March - 2020 */
/* First you need to convert the excel to csv, replacing the field termination by ; and the line termination by \n */ 

/* SET THE PATH WHERE YOU HAVE THE Alle systemer og programer_181115.xlsx FILE*/
SET @path_load = "/home/goldenfox/Documentos/CentOS/Documents/Project/Alle systemer og programmer_181115.xlsx";

CREATE TABLE AUX_SYST (
	systId INT PRIMARY KEY,
	systType VARCHAR2(14),
	navn VARCHAR(80),
	Beskrivelse TEXT,
);


CREATE TABLE systKoordinator (
	systKoordinatorId INT,
	systKoordinator VARCHAR2(30)
);

CREATE TABLE systemeier (
	systemeierId INT AUTO_INCREMENT,
	systemeierName VARCHAR(30),
	FOREING KEY ( systemeierName ) REFERENCES systemeierKoordinator ( systKoordinatorId )
);

CREATE TABLE systemeier_systkoordinator (
	systemeierId INT,
	systKoordinatorId INT, 
	FOREING KEY
	FOREING KEY
);

CREATE TABLE beskrivelse (
	beskId PRIMARY KEY AUTO_INCREMENT ? ...***
	beskName VARCHAR2(80)
	beskDesc TEXT
);
CREATE TABLE system_type (
	systTypeId TINYINT PRIMARY KEY AUTO_INCREMENT,
	systType VARCHAR(24)
);

CREATE TABLE systemer_og_programer (
	systId INT PRIMARY KEY,
	systType TINYINT,
 );


LOAD DATA LOCAL INFILE @path_load INTO TABLE AUX_SYST
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
( .... );
