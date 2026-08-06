fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-ems'
description 'EMS - ambulances, revive, heal, stretchers, wheelchairs'
version '1.0.0'
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
server_scripts { 'server/main.lua' }
dependencies { 'qb-core', 'rp-dispatch' }
