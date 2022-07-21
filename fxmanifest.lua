fx_version 'bodacious'
game 'gta5'

author 'Max'
description 'jailsystem'
version '1.0.1'

lua54 'on'

shared_script {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

escrow_ignore {
}