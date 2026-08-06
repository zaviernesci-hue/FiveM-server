local FuelCache = {}

RegisterNetEvent('rp-fuel:server:save', function(plate, fuel)
    if not plate then return end
    FuelCache[plate] = fuel
    MySQL.insert('INSERT INTO rp_vehicle_fuel (plate, fuel) VALUES (?, ?) ON DUPLICATE KEY UPDATE fuel = ?', { plate, fuel, fuel })
end)

lib.callback.register('rp-fuel:getFuel', function(_, plate)
    if FuelCache[plate] then return FuelCache[plate] end
    local r = MySQL.scalar.await('SELECT fuel FROM rp_vehicle_fuel WHERE plate = ?', { plate })
    return r or 100.0
end)

RegisterNetEvent('rp-fuel:server:pay', function(liters, cost)
    local src = source
    local Player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(src)
    if not Player or cost <= 0 then return end
    if Player.PlayerData.money.cash >= cost then
        Player.Functions.RemoveMoney('cash', cost, 'fuel')
    elseif Player.PlayerData.money.bank >= cost then
        Player.Functions.RemoveMoney('bank', cost, 'fuel')
    else
        TriggerClientEvent('ox_lib:notify', src, { title = 'Fuel', description = 'Not enough money', type = 'error' })
    end
end)
