LOAD DATA LOCAL INFILE "/home/goldenfox/Escritorio/test1.csv" INTO TABLE RawData_Update
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett, tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger);
--SET sysType_Id = CONCAT( 'SYS_', SUBSTR(systemtype,1, 3),'_',  CONVERT(LPAD(system_id,5,0), CHAR) );

-- Update the rows that changed its content
UPDATE RawData as R
INNER JOIN( SELECT * from RawData_Update r WHERE (r.systemtype,r.system_id) IN (SELECT U.systemtype,U.system_id FROM RawData as U) ) as t
ON ((t.systemtype,t.system_id) = (R.systemtype,R.system_id))
SET R.navn = t.navn ,  R.beskrivelse = t.beskrivelse , R.systemeier = t.systemeier , R.systemkoordinator = t.systemkoordinator , R.admsone = t.admsone , R.sikker_sone = t.sikker_sone , R.tu_nett = t.tu_nett , R.personopplysninger = t.personopplysninger , R.sensitive_personopplysninger = t.sensitive_personopplysninger, R.lastModified = LOCALTIME, R.isDeleted = t.isDeleted, R.source = t.source
WHERE (R.systemtype = t.systemtype AND R.system_id = t.system_id) AND ( R.navn <> t.navn OR  R.beskrivelse <> t.beskrivelse OR R.systemeier <> t.systemeier OR R.systemkoordinator <> t.systemkoordinator OR R.admsone <> t.admsone OR R.sikker_sone <> t.sikker_sone OR R.tu_nett <> t.tu_nett OR R.personopplysninger <> t.personopplysninger OR R.sensitive_personopplysninger <> t.sensitive_personopplysninger OR R.isDeleted <> t.isDeleted OR R.source <> t.source);

-- Deleted ( just changing the attribute isDeleted to 1 ) the rows that doesn't appear anymore
UPDATE RawData as R
INNER JOIN( SELECT * from RawData r WHERE (r.systemtype,r.system_id) NOT IN (SELECT U.systemtype,U.system_id FROM RawData_Update as U) ) as t
ON ((t.systemtype,t.system_id) = (R.systemtype,R.system_id))
SET R.isDeleted = 1, R.lastModified = LOCALTIME;

INSERT IGNORE INTO RawData (system_id, systemtype, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett, tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger)
SELECT system_id, systemtype, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett, tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger
FROM RawData_Update;

truncate RawData_Update;
--select system_id, navn, lastModified from RawData where system_id=1;
--select system_id, navn, lastModified from RawData where lastModified='';

--SELECT R.system_id, R.navn, R.lastModified FROM RawData as R
--INNER JOIN( SELECT * from RawData_Update r WHERE (r.systemtype,r.system_id) IN (SELECT U.systemtype,U.system_id FROM RawData as U) ) as t
--ON ((t.systemtype,t.system_id) = (R.systemtype,R.system_id));