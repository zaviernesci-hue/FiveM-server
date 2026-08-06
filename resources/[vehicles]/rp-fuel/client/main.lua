local vehicleFuel = {}
local pricePerLiter = 2.85

local function getPlate(veh)
    return GetVehicleNumberPlateText(veh):gsub('%s+', '')
end

function GetFuel(veh)
    if not veh or veh == 0 then return 100 end
    local plate = getPlate(veh)
    return vehicleFuel[plate] or 100.0
end
exports('GetFuel', GetFuel)

function SetFuel(veh, level)
    if not veh or veh == 0 then return end
    vehicleFuel[getPlate(veh)] = math.max(0, math.min(100, level))
end
exports('SetFuel', SetFuel)

-- Consumption
CreateThread(function()
    while true do
        Wait(5000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped and GetIsVehicleEngineRunning(veh) then
                local plate = getPlate(veh)
                local f = vehicleFuel[plate] or 100.0
                local speed = GetEntitySpeed(veh)
                f = f - (0.02 + speed * 0.001)
                vehicleFuel[plate] = math.max(0, f)
                if f <= 0 then SetVehicleEngineOn(veh, false, true, true) end
                TriggerServerEvent('rp-fuel:server:save', plate, vehicleFuel[plate])
            end
        end
    end
end)

-- Gas stations
local stations = {
    vector3(49.42, 2778.79, 58.04), vector3(-70.21, -1761.79, 29.53),
    vector3(1207.26, -1402.05, 35.22), vector3(1181.38, -330.84, 69.31),
}

CreateThread(function()
    for _, c in ipairs(stations) do
        exports.ox_target:addSphereZone({
            coords = c, radius = 3.0,
            options = {{
                name = 'fuel', icon = 'fas fa-gas-pump', label = 'Refuel ($2.85/L)',
                canInteract = function() return IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    local plate = getPlate(veh)
                    local current = vehicleFuel[plate] or 100
                    local need = 100 - current
                    local cost = math.ceil(need * pricePerLiter)
                    TriggerServerEvent('rp-fuel:server:pay', need, cost)
                    vehicleFuel[plate] = 100
                    TriggerServerEvent('rp-fuel:server:save', plate, 100)
                    lib.notify({ title = 'Fuel', description = 'Tank filled — $' .. cost, type = 'success' })
                end,
            }},
        })
    end
end)
