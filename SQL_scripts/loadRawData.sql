LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/test_RawData.csv" INTO TABLE RawData
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett,tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger)
SET source=2;
--SET sysType_Id = CONCAT( 'SYS_', SUBSTR(systemtype,1, 3),'_',  CONVERT(LPAD(system_id,5,0), CHAR) );
