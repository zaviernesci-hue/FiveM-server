fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-housing'
description 'Buy, rent, stash, garage, keys for properties'
version '1.0.0'
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
dependencies { 'qb-core', 'ox_inventory' }
