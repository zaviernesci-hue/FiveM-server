local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-contracts:server:accept', function(typeName)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P then return end

    local pay = typeName == 'recovery' and 1800 or typeName == 'food' and 900 or 1200
    local reward = pay + math.random(150, 450)

    P.Functions.AddMoney('bank', reward, 'contract-complete')
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Contract',
        description = 'Contract accepted and paid out: $' .. reward,
        type = 'success',
    })
end)
