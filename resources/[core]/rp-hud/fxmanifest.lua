fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-hud'
description 'Modern HUD - health, armor, needs, money, fuel, compass, speed, seatbelt'
version '1.0.0'

ui_page 'html/index.html'

files { 'html/index.html', 'html/style.css', 'html/app.js' }

client_scripts { 'client/main.lua' }

dependencies { 'qb-core', 'rp-needs', 'rp-fuel' }
