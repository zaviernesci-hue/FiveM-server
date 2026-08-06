local QBCore = exports['qb-core']:GetCoreObject()
local gangCoords = vector3(1000.0, -3100.0, 5.0)

local function openGangMenu()
    lib.registerContext({
        id = 'gang_menu',
        title = 'Gang Options',
        options = {
            { title = 'Join Vagos', onSelect = function() TriggerServerEvent('rp-gangs:server:join', 'Vagos') end },
            { title = 'Join Ballas', onSelect = function() TriggerServerEvent('rp-gangs:server:join', 'Ballas') end },
            { title = 'Leave Crew', onSelect = function() TriggerServerEvent('rp-gangs:server:leave') end },
            { title = 'Claim Territory', onSelect = function() TriggerServerEvent('rp-gangs:server:claimTerritory', 1) end },
            { title = 'Collect Crew Income', onSelect = function() TriggerServerEvent('rp-gangs:server:collectIncome') end },
        },
    })
    lib.showContext('gang_menu')
end

local function nearGangZone()
    return #(GetEntityCoords(PlayerPedId()) - gangCoords) < 3.0
end

RegisterCommand('gangmenu', function()
    if nearGangZone() then
        openGangMenu()
    else
        lib.notify({ title = 'Gang', description = 'You must be near the gang territory board.', type = 'error' })
    end
end, false)
RegisterKeyMapping('gangmenu', 'Open Gang Menu', 'keyboard', 'G')

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = gangCoords,
        radius = 2.5,
        options = {{
            name = 'gang_zone',
            icon = 'fas fa-users',
            label = 'Gang Territory',
            onSelect = openGangMenu,
        }},
    })
end)
