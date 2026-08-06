local QBCore = exports['qb-core']:GetCoreObject()

local Catalog = {
    { model = 'blista', label = 'Blista', price = 8500, topSpeed = 92, acceleration = 0.52, handling = 0.62 },
    { model = 'primo', label = 'Primo', price = 9500, topSpeed = 98, acceleration = 0.56, handling = 0.64 },
    { model = 'asea', label = 'Asea', price = 12000, topSpeed = 100, acceleration = 0.54, handling = 0.63 },
    { model = 'fugitive', label = 'Fugitive', price = 18500, topSpeed = 112, acceleration = 0.66, handling = 0.72 },
    { model = 'sentinel', label = 'Sentinel', price = 22000, topSpeed = 118, acceleration = 0.68, handling = 0.74 },
    { model = 'buffalo', label = 'Buffalo', price = 29000, topSpeed = 124, acceleration = 0.70, handling = 0.76 },
    { model = 'sultan', label = 'Sultan', price = 36000, topSpeed = 128, acceleration = 0.72, handling = 0.78 },
    { model = 'baller', label = 'Baller', price = 45000, topSpeed = 120, acceleration = 0.64, handling = 0.73 },
    { model = 'schafter3', label = 'Schafter V12', price = 110000, topSpeed = 142, acceleration = 0.78, handling = 0.84 },
    { model = 'elegy2', label = 'Elegy RH8', price = 95000, topSpeed = 150, acceleration = 0.82, handling = 0.86 },
    { model = 'adder', label = 'Adder', price = 850000, topSpeed = 190, acceleration = 0.96, handling = 0.91 },
}

lib.callback.register('rp-dealership:getCatalog', function() return Catalog end)

RegisterNetEvent('rp-dealership:server:purchase', function(model, price, finance)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P then return end
    local pay = finance and math.floor(price * 0.15) or price
    if P.PlayerData.money.bank < pay then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Dealership', description = 'Insufficient funds', type = 'error' })
        return
    end
    P.Functions.RemoveMoney('bank', pay, 'vehicle-purchase')
    local plate = 'RP' .. math.random(10000, 99999)
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, plate, garage, fuel, state, balance, paymentamount, paymentsleft, financetime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        P.PlayerData.license, P.PlayerData.citizenid, model, joaat(model), plate, 'pillboxgarage', 100, 1,
        finance and (price - pay) or 0,
        finance and math.floor((price - pay) / 24) or 0,
        finance and 24 or 0,
        finance and 24 or 0,
    })
    TriggerClientEvent('ox_lib:notify', src, { title = 'Dealership', description = 'Purchased! Plate: ' .. plate, type = 'success' })
end)

RegisterNetEvent('rp-dealership:server:buyTuning', function(plate, package)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P then return end
    local cost = package == 'street' and 4000 or package == 'track' and 9000 or 15000
    if P.PlayerData.money.bank < cost then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Tuning', description = 'Insufficient funds', type = 'error' })
        return
    end
    P.Functions.RemoveMoney('bank', cost, 'tuning-shop')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Tuning', description = 'Vehicle tuned successfully', type = 'success' })
end)
