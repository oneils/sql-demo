-- Drop the existing table vehicle if it's already exist
DROP TABLE IF EXISTS vehicle;

-- Creates table vhicle
CREATE TABLE vehicle (
	vehicle_id SERIAL       NOT NULL PRIMARY KEY,
	make       VARCHAR(100) NOT NULL,
	model      VARCHAR(100) NOT NULL,
	price      NUMERIC(5)   NOT NULL,
	year       NUMERIC(4)
);

-- Drop function fillInVehicle(rowsToInsert INTEGER) in case such function exists bu have different signature or body.
DROP FUNCTION IF EXISTS fillInVehicle(rowsToInsert INTEGER );
-- Creates a function for generating and inserting dynamic data into the 'vehicle' table.
-- rowsToInsert - is amount of row to be inserted
CREATE OR REPLACE FUNCTION fillInVehicle(rowsToInsert INTEGER)
	RETURNS VOID AS $$

BEGIN
	FOR i IN 1..rowsToInsert LOOP
		INSERT INTO vehicle (make, model, price, year)
		VALUES ('make' || i,
				'model' || i,
				CAST((random() * 100000) AS NUMERIC(5)),
				-- Insert Random Year
				extract(YEAR FROM DATE(NOW() - '1 year' :: INTERVAL * ROUND(RANDOM() * 100))));
	END LOOP;

END;

$$ LANGUAGE plpgsql;