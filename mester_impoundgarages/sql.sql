-- If your garage table is not owned_vehicles then change it to your table name
ALTER TABLE `owned_vehicles`
ADD COLUMN `impounded` tinyint(1) NOT NULL DEFAULT '0';