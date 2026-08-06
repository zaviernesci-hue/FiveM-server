fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-businesses'
description 'Buy and manage small businesses for passive income'
version '1.0.0'
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
dependencies { 'qb-core', 'ox_target' }
