/* Objective: Normalize a singular table into four different tables to follow best practices as a DBA admin by creating 
a new schema, importing existing data from old schema, dropping the old schema, and defining the relationships and 
data types for the model.
Given: Singular table with 13 fields and 1984 records that provides data about a movie rental franchise inventory
*/

CREATE SCHEMA movies_normalized;
USE movies_normalized;

-- Creating the first table of 4

CREATE TABLE `movies_normalized`.`address` (
  `store_id` INT NOT NULL,
  `store_address` VARCHAR(100) NOT NULL,
  `store_city` VARCHAR(100) NOT NULL,
  `store_district` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`store_id`));
  
-- Making the primary key auto increment after generating the table

  ALTER TABLE `movies_normalized`.`address` 
CHANGE COLUMN `store_id` `store_id` INT NOT NULL AUTO_INCREMENT ;

-- Creating second table of 4

CREATE TABLE `movies_normalized`.`inventory` (
  `inventory_id` INT NOT NULL AUTO_INCREMENT,
  `film_id` INT NOT NULL,
  `store_id` INT NOT NULL,
  PRIMARY KEY (`inventory_id`));
  
  -- Creating third table of 4
  
  CREATE TABLE `movies_normalized`.`film` (
  `film_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `release_year` VARCHAR(255) NOT NULL,
  `rental_rate` DECIMAL(5,2) NOT NULL,
  `rating` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`film_id`));
  
  -- Creating last table for new schema
  
  CREATE TABLE `movies_normalized`.`staff` (
  `store_id` INT NOT NULL AUTO_INCREMENT,
  `store_manager_first_name` VARCHAR(255) NOT NULL,
  `store_manager_last_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`store_id`));
  
  -- Now that the normalized tables have been generated, it's time to import data from the old schema
  
INSERT INTO address
SELECT DISTINCT 
	store_id,
    store_address,
    store_city,
    store_district
FROM mavenmoviesmini.inventory_non_normalized;

INSERT INTO inventory
SELECT DISTINCT
	inventory_id,
    film_id,
    store_id
FROM mavenmoviesmini.inventory_non_normalized;

INSERT INTO film
SELECT DISTINCT
	film_id,
    title,
    description,
    release_year,
    rental_rate,
    rating
FROM mavenmoviesmini.inventory_non_normalized;

INSERT INTO staff
SELECT DISTINCT
	store_id,
    store_manager_first_name,
    store_manager_last_name
FROM mavenmoviesmini.inventory_non_normalized;

-- Now that the tables are generated and filled in, I'm going to set up the relationships between them, starting with the inventory table

ALTER TABLE `movies_normalized`.`inventory` 
ADD CONSTRAINT `inventory_film_id`
  FOREIGN KEY (`film_id`)
  REFERENCES `movies_normalized`.`film` (`film_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `inventory_store_id`
  FOREIGN KEY (`store_id`)
  REFERENCES `movies_normalized`.`address` (`store_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- Adding one more foreign key to inventory table

ALTER TABLE `movies_normalized`.`inventory` 
ADD CONSTRAINT `inventory_store_id2`
  FOREIGN KEY (`store_id`)
  REFERENCES `movies_normalized`.`staff` (`store_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  /* By normalizing a single 'master' table I have successfully eliminated duplicate records, reduced future potential for human errors,
  and saved company storage on the servers by eliminating duplicate records. This process is best practice for a database administrator
  across the industry. */
