fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-contracts'
description 'Contract board with active delivery and recovery jobs'
version '1.0.0'
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
dependencies { 'qb-core', 'ox_target' }
