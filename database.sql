ALTER TABLE `users` ADD COLUMN `jail_time` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jailed_date` VARCHAR(255) NOT NULL DEFAULT 'No Date';
ALTER TABLE `users` ADD COLUMN `jail_remaintime` INT NOT NULL DEFAULT '0';

CREATE TABLE `jail_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `jail_time` int DEFAULT '0',
  `jailed_by` varchar(50) DEFAULT NULL,
  `jailed_name` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `unjailed_by` varchar(50) DEFAULT NULL,
  `unjailed_date` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;