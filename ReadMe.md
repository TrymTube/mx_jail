### mx_jail

a Jail system with lots of features. 
it allows players to quit the game while in jail and the time still runs


### Install
- Download
- insert the SQL // database.sql
- Put it in the `resource` directory
- Add it in your server.cfg // `ensure mx_jail`
- Enjoy

## SQL

ALTER TABLE `users` ADD COLUMN `jail_time` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jailed_date` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jail_remaintime` INT NOT NULL DEFAULT '0';

### TOS

Do not resell or try to rip this Script in any way.


## Changelogs

Version 1.1.0

    - added the possibility to see when a prisoner got jailed // Date and Time 24h and 12h clock
    - added F6 Menu possibility // `TriggerEvent('mx_jail:openF6Menu')`


Version 1.0.3
    
    - fixed error code client/main.lua:20 when connecting

Version 1.0.2
    
    - added folders for plugins ( coming soon )
    
    - fixed error code client/main.lua:20 when connecting

Version 1.0.1
    
    - fixed showing minus time left
