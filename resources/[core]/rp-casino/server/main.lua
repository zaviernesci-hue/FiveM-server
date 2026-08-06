local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-casino:server:bet', function(amount, target)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or P.PlayerData.money.bank < amount then return end
    P.Functions.RemoveMoney('bank', amount, 'casino-bet')
    local roll = math.random(1, 12)
    local win = roll == target
    local payout = win and amount * 2 or 0
    if win then P.Functions.AddMoney('bank', payout, 'casino-win') end
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Casino',
        description = win and ('You won $' .. payout) or ('You lost. Rolled ' .. roll),
        type = win and 'success' or 'error',
    })
end)
