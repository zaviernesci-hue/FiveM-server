local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-bounties:server:post', function(amount)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or P.PlayerData.money.bank < amount then return end
    P.Functions.RemoveMoney('bank', amount, 'bounty-post')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bounty', description = 'Bounty posted', type = 'success' })
end)

RegisterNetEvent('rp-bounties:server:claim', function(amount)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P then return end
    P.Functions.AddMoney('bank', amount, 'bounty-claim')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bounty', description = 'Bounty claimed', type = 'success' })
end)
