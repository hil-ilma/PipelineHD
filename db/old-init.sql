CREATE DATABASE IF NOT EXISTS companydb;

USE companydb;

CREATE TABLE employee (
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) DEFAULT NULL,
  salary INT(11) DEFAULT NULL, 
  PRIMARY KEY(id)
);

DESCRIBE employee;

INSERT INTO employee values 
  (1, 'Ryan Ray', 20000),
  (2, 'Joe McMillan', 40000),
  (3, 'John Carter', 50000);

SELECT * FROM employee;
USE company;

DELIMITER $$

CREATE PROCEDURE `employeeAddOrEdit` (
  IN _id INT,
  IN _name VARCHAR(45),
  IN _salary INT
)
BEGIN 
  IF _id = 0 THEN
    INSERT INTO employee (name, salary)
    VALUES (_name, _salary);

    SET _id = LAST_INSERT_ID();
  ELSE
    UPDATE employee
    SET
    name = _name,
    salary = _salary
    WHERE id = _id;
  END IF;

  SELECT _id AS 'id';
END
