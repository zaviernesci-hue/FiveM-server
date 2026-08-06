fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-dispatch'
description 'Central dispatch - alerts for police, EMS, fire, taxi'
version '1.0.0'

ui_page 'html/index.html'
files { 'html/index.html', 'html/style.css', 'html/app.js' }

shared_scripts { 'shared/incidents.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/main.lua' }
client_scripts { '@ox_lib/init.lua', 'client/main.lua' }

server_exports { 'CreateIncident', 'CloseIncident' }
dependencies { 'qb-core', 'oxmysql' }
