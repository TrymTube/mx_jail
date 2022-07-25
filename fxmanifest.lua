fx_version 'bodacious'
game 'gta5'

author 'Max'
description 'jailsystem'
version '1.2.0'

lua54 'on'

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