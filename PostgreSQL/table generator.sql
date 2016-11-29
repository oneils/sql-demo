-- Creates table vhicle
CREATE TABLE vehicle (
	vehicle_id SERIAL NOT NULL,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(5) NOT NULL
);

-- Creates a function for generating and inserting dynamic data into the 'vehicle' table.
-- rowsToInsert - is amount of row to be inserted
CREATE OR REPLACE FUNCTION fillInVehicle(rowsToInsert INTEGER)
	RETURNS VOID AS $$

BEGIN
	FOR i IN 0..rowsToInsert LOOP
		INSERT INTO vehicle (make, model, price)
		VALUES ('make' || i, 'model' || i, CAST((random() * 100000) AS NUMERIC(5)));
	END LOOP;

END;

$$ LANGUAGE plpgsql;