Locales['de'] = {
    -- client/main.lua -- Notifications
    ['help_notify_checkJailTime'] = 'Drücke ~INPUT_CONTEXT~ um deine Zeit zu checken',
    ['help_notify_jailPlayer'] = 'Drücke ~INPUT_CONTEXT~ um das Prison Menu zu öffnen',
    ['notify_checkJailTime'] = '%s minuten verbleibend',
    ['notify_no_job'] = 'du hast den nötigen Job',
    ['notify_invalid_name'] = 'Name ungültig \ngebe einen gültigen Namen ein',
    ['notify_player_alrd_jail'] = 'Spieler ist bereits im Gefängnis',
    ['notify_jailed_player'] = 'Du hast %s inhaftiert',
    ['notify_cant_jail_yourself'] = 'Du kannst dich nicht selber inhaftieren',
    ['notify_max_jailtime'] = 'Die max. Inhaftierungszeit beträgt %s',
    ['notify_min_jailtime'] = 'Die min. Inhaftierungszeit beträgt %s',
    ['notify_unjailed_player'] = 'Du hast %s erfolgreich inhaftiert',
    ['notify_updated_jailtime'] = 'Du hast die Inhaftierungszeit von %s, von %s zu %s geändert',
    ['notify_jail_released'] = 'Du wurdest vom Gefängnis entlassen',
        
    -- client/main.lua
    ['title_jail_person'] = 'Inhaftiere Spieler',
    ['title_jailed_players'] = 'Inhaftierte Spieler',
    ['title_jail_menu'] = 'Inhaftierungssystem',
    ['title_jail_dialog_playername'] = 'Spielername: Max Mustermann',
    ['title_jail_dialog_jailtime'] = 'Inhaftierungszeit',
    ['title_jail_list_ply'] = 'Inhaftierte Spieler',
    ['title_jail_list_time'] = 'Orig. Zeit',
    ['title_jail_list_timeleft'] = 'Verbleibende Zeit',
    ['title_jail_list_actions'] = 'Aktionen',
    ['action_jail_list_update'] = 'Entlassen',
    ['action_jail_list_unjail'] = 'Update Inhaftierungszeit',

    -- server/commands.lua -- Commands 
    ['chatnotify_max_jailtime'] = '[^1ERROR^0] Die max. Inhaftierungszeit beträgt ^3%s',
    ['chatnotify_min_jailtime'] = '[^1ERROR^0] Die min. Inhaftierungszeit beträgt ^3%s',
    ['chatnotify_ply_doesnt_exist'] = '[^1ERROR^0] PlayerID ^3%s ^0existiert nicht',
    ['chatnotify_not_jail'] = '[^1ERROR^0] PlayerID ^3%s ^0ist nicht im Gefängnis',
    ['chatnotify_id_jailtime'] = '[^1ERROR^0] ^3<playerID> ^0und ^3<jailtime> ^0werden benötigt',
    ['chatnotify_no_perms'] = '[^1ERROR^0] ^0Du hast nicht die ^3berechtigung ^0um den Command zu nutzen',
    ['chatnotify_id'] = '[^1ERROR^0] ^3<playerID> ^0wird benötigt',
}