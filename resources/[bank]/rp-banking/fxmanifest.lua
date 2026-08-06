fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-banking'
description 'Banking system - transfers, history, phone app integration'
version '1.0.0'

server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }

server_exports { 'LogTransaction', 'GetBalance', 'Transfer' }
dependencies { 'qb-core', 'oxmysql' }
