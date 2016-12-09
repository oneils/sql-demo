-- PARTITIONING example

-- Drop Tables in case such tables already exist.
DROP TABLE IF EXISTS vehicle_before_2000;
DROP TABLE IF EXISTS vehicle_2000_2005;
DROP TABLE IF EXISTS vehicle_2006_2016;
DROP TABLE IF EXISTS vehicle_master;

-- Create master table which will be inherited by partitioned tables
CREATE TABLE vehicle_master (
	vehicle_id SERIAL       PRIMARY KEY NOT NULL,
	make       VARCHAR(100) NOT NULL,
	model      VARCHAR(100) NOT NULL,
	year       INTEGER   NOT NULL,
	price      NUMERIC(5)   NOT NULL
);

-- Tables stores vehicles which were manufactured before the year 2000
CREATE TABLE vehicle_before_2000
(
	PRIMARY KEY (vehicle_id),
	CHECK (year < 2000)
) INHERITS (vehicle_master);

-- Tables stores vehicles which were manufactured strting from the year 2000 and the year 2005 (2000 and 2005 inclluded)
CREATE TABLE vehicle_2000_2005
(
	PRIMARY KEY (vehicle_id),
	CHECK (year >= 2000 AND year <= 2005 )
) INHERITS (vehicle_master);

-- Tables stores vehicles which were manufactured strting from the year 2006 and the year 2016 (2006 and 2016 inclluded)
CREATE TABLE vehicle_2006_2016
(
	PRIMARY KEY (vehicle_id),
	CHECK (year >= 2006 AND year <= 2016 )
) INHERITS (vehicle_master);

-- Tables stores vehicles which were manufactured strting from the year 2006 and the year 2016 (2006 and 2016 inclluded)
CREATE TABLE vehicle_after_2017
(
	PRIMARY KEY (vehicle_id),
	CHECK (year >= 2017)
) INHERITS (vehicle_master);


-- TRIGGER Function which inserts vehicle into an appropriate partitioned table according to the year in which it was manufactured
DROP FUNCTION IF EXISTS vehicle_insert();
CREATE OR REPLACE FUNCTION vehicle_insert()
	RETURNS TRIGGER AS $$
BEGIN
	IF NEW.year < 2000
	THEN
		INSERT INTO vehicle_before_2000 VALUES (NEW.*);

	ELSEIF NEW.year >= 2000 AND NEW.year <= 2005
		THEN
			INSERT INTO vehicle_2000_2005 VALUES (NEW.*);

	ELSEIF NEW.year >= 2006 AND NEW.year <= 2016
		THEN
			INSERT INTO vehicle_2006_2016 VALUES (NEW.*);

	ELSEIF NEW.year >= 2017
		THEN
			INSERT INTO vehicle_after_2017 VALUES (NEW.*);
	ELSE
		RAISE EXCEPTION 'YEAR is out of range. Something is wrong with
vehicle_insert_trigger() function';
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- Create TRIGGER which will execute vehicle_insert when new record is being inserted, updated or deleted into vehicle_master table
DROP TRIGGER IF EXISTS vehicle_year_trigger ON vehicle_master;

CREATE TRIGGER vehicle_year_trigger
BEFORE INSERT ON vehicle_master
FOR EACH ROW
EXECUTE PROCEDURE vehicle_insert();


-- Function for filling in vehicle_master table by randomly generated values
DROP FUNCTION IF EXISTS fillinvehicle_distributed(rowsToInsert INTEGER );
-- Creates a function for generating and inserting dynamic data into the 'vehicle' table.
-- rowsToInsert - is amount of row to be inserted
CREATE OR REPLACE FUNCTION fillinvehicle_distributed(rowsToInsert INTEGER)
	RETURNS VOID AS $$

BEGIN
	FOR i IN 1..rowsToInsert LOOP
		INSERT INTO vehicle_master (make, model, price, year)
		VALUES ('make' || i,
				'model' || i,
				CAST((random() * 100000) AS NUMERIC(5)),
				extract(YEAR FROM DATE(NOW() - '1 year' :: INTERVAL * ROUND(RANDOM() * 100))));
	END LOOP;

END;

$$ LANGUAGE plpgsql;