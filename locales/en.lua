Locales['en'] = {
    -- client/main.lua -- Notifications
    ['help_notify_checkJailTime'] = 'Press ~INPUT_CONTEXT~ to check your jail time',
    ['help_notify_jailPlayer'] = 'Press ~INPUT_CONTEXT~ to open the Jail Menu',
    ['notify_checkJailTime'] = '%s minutes left',
    ['notify_no_job'] = 'you do not have the required Job',
    ['notify_invalid_name'] = 'name invalid \nenter a valid name',
    ['notify_player_alrd_jail'] = 'player is already in jail',
    ['notify_jailed_player'] = 'you have jailed %s',
    ['notify_cant_jail_yourself'] = 'you can\'t jail yourself',
    ['notify_max_jailtime'] = 'the maximum jailtime is %s',
    ['notify_min_jailtime'] = 'the minimum jailtime is %s',
    ['notify_unjailed_player'] = 'you have successfully unjailed %s %s',
    ['notify_updated_jailtime'] = 'you have updated the jailtime of %s from %s to %s minutes',
    ['notify_jail_released'] = 'you got released from the jail',
        
    -- client/main.lua
    ['title_jail_person'] = 'Jail Person',
    ['title_jailed_players'] = 'Jailed Players',
    ['title_jail_menu'] = 'Jail System',
    ['title_jail_dialog_playername'] = 'enter person name: Max Mustermann',
    ['title_jail_dialog_jailtime'] = 'Jailtime',
    ['title_jail_list_ply'] = 'Jailed Person',
    ['title_jail_list_time'] = 'Orig. Time',
    ['title_jail_list_timeleft'] = 'Time Left',
    ['title_jail_list_date'] = 'Date',
    ['title_jail_list_actions'] = 'Actions',
    ['action_jail_list_update'] = 'Update Jailtime',
    ['action_jail_list_unjail'] = 'Unjail',
    ['title_jail_dialog_update_jailtime'] = 'Update Jailtime of %s',

    ['title_not_unjailed'] = 'not released yet',
    ['title_jail_history'] = 'Prison Logs',
    ['title_jailed_id'] = 'ID',
    ['title_jailed_name'] = 'Name',
    ['title_jailed_date'] = 'Jailed on',
    ['title_jail_time'] = 'Jail Time',
    ['title_jailed_by'] = 'Jailed by',
    ['title_unjailed_by'] = 'Released by',
    ['title_unjailed_date'] = 'Released on',
    ['title_released'] = 'Jailtime Served',

    -- plugins/mx_jailbreak/jailbreak_client.lua
    ['title_jailbreak'] = 'Broken Out',

    -- server/commands.lua -- Commands 
    ['chatnotify_max_jailtime'] = '[^1ERROR^0] The maximum jailtime is ^3%s',
    ['chatnotify_min_jailtime'] = '[^1ERROR^0] The minimum jailtime is ^3%s',
    ['chatnotify_ply_doesnt_exist'] = '[^1ERROR^0] PlayerID ^3%s ^0does not exist!!',
    ['chatnotify_not_jail'] = '[^1ERROR^0] PlayerID ^3%s ^0is not in jail!',
    ['chatnotify_id_jailtime'] = '[^1ERROR^0] ^3<playerID> ^0and ^3<jailtime> ^0required',
    ['chatnotify_no_perms'] = '[^1ERROR^0] ^0you do not have ^3permission ^0to use that command',
    ['chatnotify_id'] = '[^1ERROR^0] ^3<playerID> ^0required',
}