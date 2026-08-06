--[[ rp-banking server ]]

local QBCore = exports['qb-core']:GetCoreObject()

function LogTransaction(citizenid, txType, amount, description)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    local balance = 0
    if Player then balance = Player.PlayerData.money.bank end
    MySQL.insert('INSERT INTO rp_bank_transactions (citizenid, type, amount, balance_after, description) VALUES (?, ?, ?, ?, ?)', {
        citizenid, txType, amount, balance, description or ''
    })
end
exports('LogTransaction', LogTransaction)

exports('GetBalance', function(citizenid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    return Player and Player.PlayerData.money.bank or 0
end)

exports('Transfer', function(fromSrc, toCitizenId, amount, note)
    local Player = QBCore.Functions.GetPlayer(fromSrc)
    if not Player or amount <= 0 then return false, 'invalid' end
    if Player.PlayerData.money.bank < amount then return false, 'insufficient' end
    local Target = QBCore.Functions.GetPlayerByCitizenId(toCitizenId)
    if not Target then return false, 'offline' end
    Player.Functions.RemoveMoney('bank', amount, 'transfer-out')
    Target.Functions.AddMoney('bank', amount, 'transfer-in')
    LogTransaction(Player.PlayerData.citizenid, 'transfer_out', -amount, note)
    LogTransaction(toCitizenId, 'transfer_in', amount, note)
    return true
end)

lib.callback.register('rp-banking:getHistory', function(source, limit)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return {} end
    return MySQL.query.await('SELECT * FROM rp_bank_transactions WHERE citizenid = ? ORDER BY created_at DESC LIMIT ?', {
        Player.PlayerData.citizenid, limit or 25
    }) or {}
end)

RegisterNetEvent('rp-banking:server:deposit', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not amount or amount <= 0 then return end
    if exports.ox_inventory:GetItemCount(src, 'bank_card') < 1 then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'You need a bank card to use banking services.', type = 'error' })
        return
    end
    if Player.PlayerData.money.cash < amount then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'Not enough cash.', type = 'error' })
        return
    end
    Player.Functions.RemoveMoney('cash', amount, 'bank-deposit')
    Player.Functions.AddMoney('bank', amount, 'bank-deposit')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = '$' .. amount .. ' deposited', type = 'success' })
end)

RegisterNetEvent('rp-banking:server:withdraw', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not amount or amount <= 0 then return end
    if exports.ox_inventory:GetItemCount(src, 'bank_card') < 1 then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'You need a bank card to use banking services.', type = 'error' })
        return
    end
    if Player.PlayerData.money.bank < amount then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'Not enough bank funds.', type = 'error' })
        return
    end
    Player.Functions.RemoveMoney('bank', amount, 'bank-withdraw')
    Player.Functions.AddMoney('cash', amount, 'bank-withdraw')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = '$' .. amount .. ' withdrawn', type = 'success' })
end)

RegisterNetEvent('rp-banking:server:transfer', function(targetId, amount, note)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not Player or not Target or amount <= 0 then return end
    if exports.ox_inventory:GetItemCount(src, 'bank_card') < 1 then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'You need a bank card to use banking services.', type = 'error' })
        return
    end
    local ok, err = exports['rp-banking']:Transfer(src, Target.PlayerData.citizenid, amount, note)
    TriggerClientEvent('ox_lib:notify', src, {
        title = ok and 'Transfer Sent' or 'Transfer Failed',
        description = ok and ('$' .. amount .. ' sent') or (err or 'failed'),
        type = ok and 'success' or 'error',
    })
end)
