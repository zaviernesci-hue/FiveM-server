local terminal = vector3(-1082.22, -247.78, 37.76)

local function openMarketplaceMenu()
    lib.callback('rp-marketplace:getListings', false, function(listings)
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', listings = listings })
    end)
end

local function nearMarketplaceTerminal()
    return #(GetEntityCoords(PlayerPedId()) - terminal) < 2.0
end

RegisterNetEvent('rp-marketplace:client:openMenu', openMarketplaceMenu)

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = terminal, radius = 1.5,
        options = {{
            name = 'market', icon = 'fas fa-store', label = 'Marketplace Terminal',
            onSelect = openMarketplaceMenu,
        }},
    })
end)

RegisterNUICallback('close', function(_, cb) SetNuiFocus(false, false); cb('ok') end)
RegisterNUICallback('buy', function(d, cb) TriggerServerEvent('rp-marketplace:server:buy', d.id); cb('ok') end)
RegisterNUICallback('bid', function(d, cb) TriggerServerEvent('rp-marketplace:server:bid', d.id, d.amount); cb('ok') end)
RegisterNUICallback('create', function(d, cb) TriggerServerEvent('rp-marketplace:server:createListing', d); cb('ok') end)
