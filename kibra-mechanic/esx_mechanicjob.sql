USE `es_extended`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_mekanik3', 'Mekanik 3', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_mekanik3', 'Mekanik 3', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_mekanik3', 'Mekanik 3', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('mekanik3', 'Mekanik 3')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('mekanik3',0,'recrue','Stajyer',12,'{}','{}'),
	('mekanik3',1,'novice','Tekniker',24,'{}','{}'),
	('mekanik3',2,'experimente','Usta',36,'{}','{}'),
	('mekanik3',3,'chief',"Muhasebe",48,'{}','{}'),
	('mekanik3',4,'boss','Patron',0,'{}','{}')
;
