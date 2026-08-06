fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-police'
description 'LSPD - duty, armory, MDT, cuffs, taser, spike strips, radar'
version '1.0.0'
client_scripts { '@ox_lib/init.lua', 'client/*.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
dependencies { 'qb-core', 'rp-dispatch', 'ox_inventory' }
