local QBCore = exports['qb-core']:GetCoreObject()
local bountyCoords = vector3(229.0, -1342.5, 24.0)

local function openBountyMenu()
    lib.registerContext({
        id = 'bounty_menu',
        title = 'Bounty Board',
        options = {
            { title = 'Post Bounty ($10k)', onSelect = function() TriggerServerEvent('rp-bounties:server:post', 10000) end },
            { title = 'Claim Bounty ($8k)', onSelect = function() TriggerServerEvent('rp-bounties:server:claim', 8000) end },
        },
    })
    lib.showContext('bounty_menu')
end

local function nearBountyBoard()
    return #(GetEntityCoords(PlayerPedId()) - bountyCoords) < 3.0
end

RegisterNetEvent('rp-bounties:client:openBoard', openBountyMenu)

CreateThread(function()
    local coords = bountyCoords
    exports.ox_target:addSphereZone({
        coords = coords,
        radius = 2.3,
        options = {{
            name = 'bounty_board',
            icon = 'fas fa-user-slash',
            label = 'Bounty Board',
            onSelect = openBountyMenu,
        }},
    })
end)
