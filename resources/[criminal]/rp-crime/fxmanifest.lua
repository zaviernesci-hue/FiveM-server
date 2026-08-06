fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-crime'
description 'ATM and bank robberies with police dispatch alerts'
version '1.0.0'
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
server_scripts { 'server/main.lua' }
dependencies { 'qb-core', 'rp-dispatch', 'ox_inventory' }
