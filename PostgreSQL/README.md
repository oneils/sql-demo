
## Description
`vehicle_table_generator.sql` is a SQL script which
* creates `vehicle` table
* creates function for generating and inserting random data into `vehicle` table

## How to use
Just run the script using any suitable approach(e.g. using psql or any database managment tool)

After executing `vehicle_table_generator.sql` `vehicle` table and `fillInVehicle` function should be created.

To fill in `vehicle` table by random data call `fillInVehicle` function and specify the amount of calumns to be inserted into the table:
```
SELECT fillInVehicle(100);
```

The command above will insert randomly generated data into 100 rows.

To verify data was successfully inserted into `vehicle` table:
```
SELECT count(*) FROM vehicle;
```

The output should be:
```
100
```