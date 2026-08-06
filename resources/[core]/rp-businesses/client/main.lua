local QBCore = exports['qb-core']:GetCoreObject()
local businessCoords = vector3(-156.1, -583.1, 32.6)

local function openBusinessMenu()
    lib.registerContext({
        id = 'business_menu',
        title = 'Businesses',
        options = {
            { title = 'Buy Coffee Shop ($250k)', onSelect = function() TriggerServerEvent('rp-businesses:server:buy', 'coffee') end },
            { title = 'Buy Bar ($400k)', onSelect = function() TriggerServerEvent('rp-businesses:server:buy', 'bar') end },
            { title = 'Buy Gas Station ($600k)', onSelect = function() TriggerServerEvent('rp-businesses:server:buy', 'gas') end },
        },
    })
    lib.showContext('business_menu')
end

local function nearBusinessCenter()
    return #(GetEntityCoords(PlayerPedId()) - businessCoords) < 3.0
end

RegisterNetEvent('rp-businesses:client:openMenu', openBusinessMenu)

CreateThread(function()
    local coords = businessCoords
    exports.ox_target:addSphereZone({
        coords = coords,
        radius = 2.2,
        options = {{
            name = 'business_shop',
            icon = 'fas fa-store',
            label = 'Business Center',
            onSelect = openBusinessMenu,
        }},
    })
end)
