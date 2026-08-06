local QBCore = exports['qb-core']:GetCoreObject()
local drugCoords = vector3(-1172.4, -1570.0, 4.6)

local function openDrugMenu()
    lib.registerContext({
        id = 'drug_menu',
        title = 'Drug Operations',
        options = {
            { title = 'Produce Weed ($1,250)', onSelect = function() TriggerServerEvent('rp-drugs:server:produce', 'weed') end },
            { title = 'Produce Meth ($2,400)', onSelect = function() TriggerServerEvent('rp-drugs:server:produce', 'meth') end },
            { title = 'Sell Weed', onSelect = function() TriggerServerEvent('rp-drugs:server:sell', 'weed') end },
            { title = 'Sell Meth', onSelect = function() TriggerServerEvent('rp-drugs:server:sell', 'meth') end },
        },
    })
    lib.showContext('drug_menu')
end

local function nearDrugLab()
    return #(GetEntityCoords(PlayerPedId()) - drugCoords) < 3.0
end

RegisterNetEvent('rp-drugs:client:openLab', openDrugMenu)

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = drugCoords,
        radius = 2.5,
        options = {{
            name = 'drug_lab',
            icon = 'fas fa-flask',
            label = 'Drug Lab',
            onSelect = openDrugMenu,
        }},
    })
end)
