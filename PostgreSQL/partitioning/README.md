## Description
This folder contains examples related to the `Distribution` in PostreSQL.

## partitioning_example.sql
`partitioning_example.sql` is a SQL script which
* creates parent `vehicle_master` table for partitioned tables
* creates partitioned tables which inherit `vehicle_master` table. Each table stores data according to the year range, e.g.:
 * vehicles which were produced before the year 2000;
 * vehicles which were produces between 2000 and 2005;
 * and so and so forth
* trigger function `vehicle_insert` which inserts vehicle into an appropriate partitioned table according to the year in which it was manufactured
* creates function for inserting randomly generated data into `vehicle_master` table
* creates trigger `vehicle_year_trigger` which executes `vehicle_insert` function when vehicle is being inserted, updated or deleted in/from `vehicle_master` table
* creates `fillinvehicle_distributed` function which can be used for inserted randomly generated data into `vehicle_master` table

## How to use
Just run the script using any suitable approach(e.g. using psql or any database managment tool)

After executing this script all mentioned above tables, functions and trigger will be created.

To fill in `vehicle` table by random data call `fillinvehicle_distributed` function and specify the amount of columns to be inserted into the table:
```sql
SELECT fillinvehicle_distributed(10000);
```

The command above will insert randomly generated data into 10000 rows.

To verify data was successfully inserted into `vehicle` table:
```sql
SELECT count(*) FROM vehicle_master;
```

The output should be:
```
10000
```

## Verify vehicles inserted correctly according to the year range
To verify vehicles are inserted correctly according to the specified year ranges in `vehicle_insert` function the following queries can be used:
```sql
SELECT count(*) as total_years, min(year) as min_year, max(year) as max_year FROM vehicle_master;

SELECT count(*) as total_years, min(year) as min_year, max(year) as max_year FROM vehicle_before_2000;

SELECT count(*) as total_years, min(year) as min_year, max(year) as max_year  FROM vehicle_2000_2005;

SELECT count(*) as total_years, min(year) as min_year, max(year) as max_year  FROM vehicle_2006_2016;
```

The output for `vehicle_master` table will look into the following way:
<table>
	<th>total_years</th>
	<th>min_year</th>
	<th>max_year</th>
	<tr>
		<td>10000</td>
		<td>1916</td>
		<td>2016</td>
	</tr>
</table>