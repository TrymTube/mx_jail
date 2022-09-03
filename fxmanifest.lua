fx_version 'bodacious'
game 'gta5'

author 'Max'
description 'jailsystem'
version '1.3.0'

lua54 'yes'

shared_script {
	'@es_extended/imports.lua',
	'plugins/**/*_shared.lua',
	'plugins/**/*_config.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
	'plugins/**/*_client.lua',
	'client/*.lua'
}

server_scripts {
	'plugins/**/*_server.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

escrow_ignore {
}


function OpenPoliceActionsMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
        title    = 'Police',
        align    = 'top-left',
        elements = {
            {label = _U('citizen_interaction'), value = 'citizen_interaction'},
            {label = _U('vehicle_interaction'), value = 'vehicle_interaction'},,
            {label = _U('open_jail_menu'), value = 'jail_menu'}
            {label = _U('object_spawner'), value = 'object_spawner'}
    }}, function(data, menu)
        if data.current.value == 'jail_menu' then
			TriggerEvent('mx_jail:openF6Menu')
		elseif data.current.value == 'citizen_interaction' then
            local elements = {
                {label = _U('id_card'), value = 'identity_card'},
                {label = _U('search'), value = 'search'},
                {label = _U('handcuff'), value = 'handcuff'},
                {label = _U('drag'), value = 'drag'},
                {label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
                {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
                {label = _U('fine'), value = 'fine'},
                {label = _U('unpaid_bills'), value = 'unpaid_bills'}
            }

            if Config.EnableLicenses then
                table.insert(elements, {label = _U('license_check'), value = 'license'})
            end