/* Objective: Create a database from the ground up for a fictional baby merchandise company
that specializes in baby booties with 3 plausible records for each table */

-- Create necessary tables to track customers, employees, products, and purchases
CREATE SCHEMA bubsbooties;
USE bubsbooties;

-- Creating customers table

CREATE TABLE `bubsbooties`.`customers` (
  `customer_id` BIGINT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE);
  
  -- Creating employees table
  
  CREATE TABLE `bubsbooties`.`employees` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `start_date` DATE NOT NULL,
  `position` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`employee_id`));
  
  -- Creating products table
  
  CREATE TABLE `bubsbooties`.`products` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE);
  
  -- Creating purchases table
  
  CREATE TABLE `bubsbooties`.`purchases` (
  `purchase_id` BIGINT NOT NULL,
  `customer_id` BIGINT NOT NULL,
  `purchase_date` DATE NOT NULL,
  `cost` DECIMAL(5,2) NOT NULL,
  `product_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  PRIMARY KEY (`purchase_id`));
  
  -- Creating relationships to the three lookup tables for the purchase table (fact table)
  
ALTER TABLE `bubsbooties`.`purchases` 
ADD CONSTRAINT `1`
  FOREIGN KEY (`customer_id`)
  REFERENCES `bubsbooties`.`customers` (`customer_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `2`
  FOREIGN KEY (`product_id`)
  REFERENCES `bubsbooties`.`products` (`product_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `3`
  FOREIGN KEY (`employee_id`)
  REFERENCES `bubsbooties`.`employees` (`employee_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  -- Insert 3 records for each table
  
  INSERT INTO customers VALUES
  (1, 'george', 'washington', 'georgewashington@gmail.com'),
  (2, 'leslie', 'dailey', 'lesdailey3@gmail.com'),
  (3, 'monkey', 'luffy', 'monkeydluffy@gmail.com');
  
  INSERT INTO employees VALUES
  (1, 'john', 'doe', '2022-9-14', 'cashier'),
  (2, 'samantha', 'orville', '2022-9-14', 'stocker'),
  (3, 'benjamin', 'franklin', '2022-9-14', 'manager');
  
  INSERT INTO products VALUES
  (1, 'pink bootie', 50.99),
  (2, 'blue bootie', 42.99),
  (3, 'black bootie', 60.99);
  
  INSERT INTO purchases VALUES
  (1, 1, '2022-09-14', 50.99, 1, 1),
  (2, 2, '2022-09-14', 50.99, 1, 1),
  (3, 2, '2022-09-14', 60.99, 3, 1);
  
  -- Dropping cost column from purchases table since value can be found in product lookup table
  
  ALTER TABLE purchases
  DROP COLUMN cost;