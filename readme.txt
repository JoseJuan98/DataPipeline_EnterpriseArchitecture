Contrainsts of the system:
	- USERS MUST NOT BE ABLE TO MAKE DELETES OF THE DATA. If not the model will lose the track of the data.
	- Beskrivelse or description with especial character ',' should be enclosed by the character '"'.
	- Updates of the model must be carried with only on the auxiliar table for updates and with the scripts for updating. The triggers will display the rest of updates.
	- The identifiers of the data or rows (primary keys) can not be change or the model is not going to be updated properly.
	- For a correct format to load the date you need the string delimiter with the char '"', the line delimiter with the char '\n' and the field, attribute or separator with the char ','. 
		Also the file can not have any empty line.

Maintainance
	- If you want to add new data to the model insert ONLY new rows into RawData
	- If you want to update the model insert into the table RawData_Update using the script Update.sql . But be careful because the rows that in RawData but not in RawData_Update are going to be deleted (isDeleted=1) from RawData and its respective rows in the rest of tables.
	Model behaviour
	- To update properly all the file when they are going to be updated need to have a first line with all the atributes name



		Person
			- If a person is not a systemkoordinator or systemeier and you want to deleted from the table person uncomment the respective code in Update.sql script
				At the moment the person are not deleted because they can be working in another system
				
Be careful with:
	- The attribute sysId in the table system references to the system_id from the RawData,
	meanwhile the sysId attribute from other tables references the id (primary key) of the table system.
