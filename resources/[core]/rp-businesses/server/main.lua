local QBCore = exports['qb-core']:GetCoreObject()

local BusinessPrices = {
    coffee = 250000,
    bar = 400000,
    gas = 600000,
}

RegisterNetEvent('rp-businesses:server:buy', function(businessType)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not BusinessPrices[businessType] then return end
    local price = BusinessPrices[businessType]
    if P.PlayerData.money.bank < price then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Business', description = 'Insufficient funds', type = 'error' })
        return
    end
    P.Functions.RemoveMoney('bank', price, 'business-purchase')
    P.Functions.SetMetaData('business', businessType)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Business', description = 'Business purchased successfully', type = 'success' })
end)
