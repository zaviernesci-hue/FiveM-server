local QBCore = exports['qb-core']:GetCoreObject()
local contractCoords = vector3(250.5, -1347.7, 24.0)

local function openContractsMenu()
    lib.registerContext({
        id = 'contracts_menu',
        title = 'Available Contracts',
        options = {
            { title = 'Courier Run', onSelect = function() TriggerServerEvent('rp-contracts:server:accept', 'courier') end },
            { title = 'Recovery Job', onSelect = function() TriggerServerEvent('rp-contracts:server:accept', 'recovery') end },
            { title = 'Food Delivery', onSelect = function() TriggerServerEvent('rp-contracts:server:accept', 'food') end },
        },
    })
    lib.showContext('contracts_menu')
end

local function nearContractBoard()
    return #(GetEntityCoords(PlayerPedId()) - contractCoords) < 3.0
end

RegisterNetEvent('rp-contracts:client:openBoard', openContractsMenu)

CreateThread(function()
    local coords = contractCoords
    exports.ox_target:addSphereZone({
        coords = coords,
        radius = 2.5,
        options = {{
            name = 'contracts_board',
            icon = 'fas fa-clipboard-list',
            label = 'Contract Board',
            onSelect = openContractsMenu,
        }},
    })
end)
