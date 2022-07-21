### mx_jail

a Jail system with lots of features. 
it allows players to quit the game while in jail and the time still runs


### Install
- Download
- the DB Column should be created automaticly if not insert the SQL down below
- Put it in the `resource` directory
- Add it in your server.cfg
- Enjoy

```
ensure mx_jail
```

## SQL

ALTER TABLE `users` ADD COLUMN `jail_time` INT NOT NULL DEFAULT '0';
ALTER TABLE `users` ADD COLUMN `jail_remaintime` INT NOT NULL DEFAULT '0';

### TOS

Do not resell or try to rip this Script in any way.
