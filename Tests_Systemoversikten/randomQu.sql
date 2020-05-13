-- To check if update.sql inserts in other tables after updates
select distinct(createdDate) from X_table;

-- To check if update.sql updates rows in other tables after updates
select distinct(lastModified) from X_table;


select * from system where lastModified='2020-05-13 14:30:18';
