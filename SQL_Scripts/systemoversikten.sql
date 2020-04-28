CREATE TABLE systemType (
	sysTypeId INT,
	name VARCHAR(255)
);



CREATE TABLE system (
	sysId INT,
	navn VARCHAR(255),
	sysType INT,
	beskrivelse TEXT,
	PRIMARY KEY (sysId),
	FOREIGN KEY (sysType) REFERENCES systemType (sysTypeId)
);


CREATE TABLE person (
	persId INT,
	name VARCHAR(255)
);


CREATE TABLE systemKoordinator (
	sysKoorId INT,
	FOREIGN KEY (sysKoordId) REFERENCES person (persId)
);


CREATE TABLE systemeier (
	sysMeiId INT,
	FOREIGN KEY (sysMeiId) REFERENCES person (persId)
);

CREATE TABLE personalCapability (


);


CREATE TABLE networkCapability (


);
