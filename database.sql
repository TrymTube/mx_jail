ALTER TABLE `users` ADD COLUMN `jail_time` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jailed_date` VARCHAR(255) NOT NULL DEFAULT 'No Date';
ALTER TABLE `users` ADD COLUMN `jail_remaintime` INT NOT NULL DEFAULT '0';