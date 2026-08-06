fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'rp-core'
description 'Core bridge for Los Santos Roleplay - config loader, paychecks, exports'
author 'Los Santos RP'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

client_scripts {
    'client/*.lua',
}

dependencies {
    'ox_lib',
    'oxmysql',
    'qb-core',
}

exports {
    'GetConfig',
    'GetJobs',
    'GetVehicles',
}

server_exports {
    'GetConfig',
    'GetJobs',
    'GetPlayerCitizenId',
    'AddBankMoney',
    'RemoveBankMoney',
    'LogTransaction',
}
