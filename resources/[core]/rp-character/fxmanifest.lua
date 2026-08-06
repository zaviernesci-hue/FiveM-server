fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-character'
description 'Character creation - blocks emergency uniforms at creation'
version '1.0.0'

client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
server_scripts { 'server/main.lua' }

dependencies { 'qb-core', 'illenium-appearance', 'qb-multicharacter' }
