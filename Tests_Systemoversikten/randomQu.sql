-- To check if update.sql inserts in other tables after updates
select distinct(createdDate) from X_table;

-- To check if update.sql updates rows in other tables after updates
select distinct(lastModified) from X_table;


select * from system where lastModified='2020-05-13 14:30:18';


-- To check System_Person_Role
SELECT distinct(systemeier) FROM RawData where systemeier NOT IN (select distinct(systemeier) from RawData_Update);
select * from System_Person_Role where roleId=1 and isDeleted=1;
select * from person where persId IN (1,3,4,12);