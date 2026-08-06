fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'rp-dealership'
description 'Vehicle dealership - browse, test drive, buy, finance'
version '1.0.0'
ui_page 'html/index.html'
files { 'html/index.html', 'html/style.css', 'html/app.js' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
dependencies { 'qb-core' }
