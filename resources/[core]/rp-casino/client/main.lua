local QBCore = exports['qb-core']:GetCoreObject()
local casinoCoords = vector3(1088.0, 208.0, -49.0)

local function openCasinoMenu()
    lib.registerContext({
        id = 'casino_menu',
        title = 'Casino',
        options = {
            { title = 'Bet $500 on 7', onSelect = function() TriggerServerEvent('rp-casino:server:bet', 500, 7) end },
            { title = 'Bet $500 on 11', onSelect = function() TriggerServerEvent('rp-casino:server:bet', 500, 11) end },
        },
    })
    lib.showContext('casino_menu')
end

local function nearCasinoTable()
    return #(GetEntityCoords(PlayerPedId()) - casinoCoords) < 3.0
end

RegisterNetEvent('rp-casino:client:openTable', openCasinoMenu)

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = casinoCoords,
        radius = 2.0,
        options = {{
            name = 'casino_table',
            icon = 'fas fa-dice',
            label = 'Casino Table',
            onSelect = openCasinoMenu,
        }},
    })
end)
