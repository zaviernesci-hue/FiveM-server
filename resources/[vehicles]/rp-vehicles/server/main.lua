local QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('rp-vehicles:getOwned', function(source)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return {} end
    return MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { P.PlayerData.citizenid }) or {}
end)

RegisterNetEvent('rp-vehicles:server:spawn', function(plate)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    local veh = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', { plate, P.PlayerData.citizenid })
    if not veh then return end
    TriggerClientEvent('rp-vehicles:client:spawn', src, veh)
end)

RegisterNetEvent('rp-vehicles:server:sell', function(plate, price)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    local veh = MySQL.single.await('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?', { plate, P.PlayerData.citizenid })
    if not veh then return end
    MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', { plate })
    P.Functions.AddMoney('bank', price, 'vehicle-sell')
end)
