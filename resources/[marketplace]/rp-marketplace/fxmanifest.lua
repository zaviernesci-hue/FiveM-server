fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-marketplace'
description 'eBay-style marketplace - buy, bid, sell items and vehicles'
version '1.0.0'
ui_page 'html/index.html'
files { 'html/index.html', 'html/style.css', 'html/app.js' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
dependencies { 'qb-core', 'ox_inventory' }
