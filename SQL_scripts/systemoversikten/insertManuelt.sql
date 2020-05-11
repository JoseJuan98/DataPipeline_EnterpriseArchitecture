-- ======================== Insert Manual Data =======================

INSERT INTO source ( name, createdDate )
VALUES ('unknown source', LOCALTIME),
( 'Systemoversikten', LOCALTIME ),
( 'Fellesdata', LOCALTIME ),
( 'Manuelt nettverk', LOCALTIME ),
( 'Manuelt rolle', LOCALTIME ),
( 'Difi', LOCALTIME ),
( 'Manuelt personopplysninger', LOCALTIME);

INSERT INTO role ( name, source )
VALUES 
('systemeier', (SELECT  srcId FROM source where name = 'Manuelt rolle')),
('systemkoordinator',(SELECT srcId FROM source where name = 'Manuelt rolle'));

INSERT INTO person_opplysninger (name, createdDate, source)
VALUES 
('persondata', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt personopplysninger')),
('Sensitive persondata', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt personopplysninger'));

INSERT INTO network (name, createdDate, source)
VALUES 
('Adm sone', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('Sikker sone', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('Elevnett', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk')),
('TU nett', LOCALTIME, (SELECT srcId FROM source WHERE name='Manuelt nettverk'));
