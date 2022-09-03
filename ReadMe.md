### mx_jail

a Jail system with lots of features. 
it allows players to quit the game while in jail and the time still runs


### Install
- Download
- insert the SQL // database.sql
- Put it in the `resource` directory
- Add it in your server.cfg // `ensure mx_jail`
- Enjoy

If you want to use the Jailmenu with your police menu then use this trigger



## SQL

ALTER TABLE `users` ADD COLUMN `jail_time` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jailed_date` VARCHAR(255) NOT NULL DEFAULT 'No Date';
ALTER TABLE `users` ADD COLUMN `jail_remaintime` INT NOT NULL DEFAULT '0';

### TOS

Do not resell or try to rip this Script in any way.


## Changelogs

Version 1.3.1

    - fixed potential xPlayer nil value // if the problem still persists contact me

Version 1.3.0

    - added possibility to set prisoner clothing
    - added jail history // insert the new jail_history.sql in order to work

Version 1.2.2

    - fixed error in line server/main.lua:6 xPlayer nil value

Version 1.2.1

    - fixed able to jail himself
    - fixed database wrong SQL Insert // insert the jailed_date new!

Version 1.2.0

    - added possibility to disable prisoner teleport when jailing

Version 1.1.0

    - added the possibility to see when a prisoner got jailed // Date and Time 24h and 12h clock
    - added F6 Menu possibility // `TriggerEvent('mx_jail:openF6Menu')`


Version 1.0.3
    
    - fixed error code client/main.lua:20 when connecting

Version 1.0.2
    
    - added folders for plugins ( coming soon )
    
    - fixed error code client/main.lua:20 when connecting

Version 1.0.1
    
    - fixed showing negative time
