fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-fuel'
description 'Vehicle fuel system with gas stations and HUD integration'
version '1.0.0'
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
exports { 'GetFuel', 'SetFuel' }
dependencies { 'qb-core', 'oxmysql' }
