ALTER TABLE owned_vehicles 
ADD `garage` VARCHAR(200) DEFAULT 'A',
ADD `state` tinyint(1) NOT NULL DEFAULT 1 AFTER `owner`;