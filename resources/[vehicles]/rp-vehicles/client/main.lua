local garages = {
    { name = 'pillboxgarage', coords = vector3(215.68, -809.69, 30.73) },
    { name = 'legionsquare', coords = vector3(215.84, -806.07, 30.78) },
}

CreateThread(function()
    for _, g in ipairs(garages) do
        exports.ox_target:addSphereZone({
            coords = g.coords, radius = 3.0,
            options = {{
                name = 'garage_'..g.name, icon = 'fas fa-warehouse', label = 'Garage',
                onSelect = function()
                    lib.callback('rp-vehicles:getOwned', false, function(vehicles)
                        local opts = {}
                        for _, v in ipairs(vehicles) do
                            opts[#opts+1] = { title = v.vehicle .. ' [' .. v.plate .. ']', onSelect = function()
                                TriggerServerEvent('rp-vehicles:server:spawn', v.plate)
                            end}
                        end
                        lib.registerContext({ id = 'garage', title = 'Garage', options = opts })
                        lib.showContext('garage')
                    end)
                end,
            }},
        })
    end
end)

RegisterNetEvent('rp-vehicles:client:spawn', function(data)
    local c = GetEntityCoords(PlayerPedId())
    lib.requestModel(data.vehicle)
    local veh = CreateVehicle(joaat(data.vehicle), c.x + 3, c.y, c.z, GetEntityHeading(PlayerPedId()), true, false)
    SetVehicleNumberPlateText(veh, data.plate)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
end)

RegisterCommand('lockcar', function()
    local veh = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, false)
    if veh then
        local locked = GetVehicleDoorLockStatus(veh) ~= 1
        SetVehicleDoorsLocked(veh, locked and 1 or 2)
        lib.notify({ title = 'Vehicle', description = locked and 'Unlocked' or 'Locked', type = 'inform' })
    end
end)
RegisterKeyMapping('lockcar', 'Lock/Unlock Vehicle', 'keyboard', 'L')
