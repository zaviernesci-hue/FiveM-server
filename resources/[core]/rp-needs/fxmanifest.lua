fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-needs'
description 'Hunger, thirst, stress - synced to QBCore metadata and database'
version '1.0.0'

server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { 'client/main.lua' }

dependencies { 'qb-core' }
