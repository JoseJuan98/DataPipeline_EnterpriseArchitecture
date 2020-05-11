UPDATE RawData as r
SET isDeleted = 1
WHERE (navn,system_id) NOT IN (SELECT navn, system_id
				FROM RawData_Update as u
				WHERE r.navn = u.navn 
					AND r.system_id = u.system_id);

