local dealer = vector3(-56.79, -1098.9, 26.42)
local uiOpen = false

local function openDealershipMenu()
    lib.callback('rp-dealership:getCatalog', false, function(catalog)
        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', catalog = catalog })
    end)
end

local function nearDealership()
    return #(GetEntityCoords(PlayerPedId()) - dealer) < 3.0
end

RegisterCommand('dealership', function()
    if nearDealership() then
        openDealershipMenu()
    else
        lib.notify({ title = 'Dealership', description = 'You must be near the dealership to open this menu.', type = 'error' })
    end
end, false)
RegisterKeyMapping('dealership', 'Open Dealership', 'keyboard', 'R')

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = dealer, radius = 2.5,
        options = {{
            name = 'pdm', icon = 'fas fa-car', label = 'Premium Deluxe Motorsport',
            onSelect = openDealershipMenu,
        }},
    })
end)

RegisterNUICallback('close', function(_, cb) uiOpen = false; SetNuiFocus(false, false); cb('ok') end)
RegisterNUICallback('buy', function(data, cb)
    TriggerServerEvent('rp-dealership:server:purchase', data.model, data.price, data.finance)
    cb('ok')
end)
RegisterNUICallback('tune', function(data, cb)
    TriggerServerEvent('rp-dealership:server:buyTuning', data.plate, data.package)
    cb('ok')
end)
RegisterNUICallback('testDrive', function(data, cb)
    local spawn = vector4(-49.5, -1111.0, 26.67, 70.0)
    lib.requestModel(data.model)
    local veh = CreateVehicle(joaat(data.model), spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    lib.notify({ title = 'Test Drive', description = '5 minutes — do not damage!', type = 'inform' })
    SetTimeout(300000, function() if DoesEntityExist(veh) then DeleteEntity(veh) end end)
    cb('ok')
end)
