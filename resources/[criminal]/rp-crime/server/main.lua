local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-crime:server:atmRobbery', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local has = exports.ox_inventory:GetItemCount(src, 'lockpick')
    if has < 1 then return end
    if math.random() < 0.25 then
        TriggerClientEvent('ox_lib:notify', src, { title = 'ATM', description = 'Lockpick broke — failed!', type = 'error' })
        exports.ox_inventory:RemoveItem(src, 'lockpick', 1)
        exports['rp-dispatch']:CreateIncident('atm_robbery', 'ATM Robbery Attempt', coords, Player.PlayerData.citizenid)
        return
    end
    local payout = math.random(1800, 6500)
    Player.Functions.AddMoney('cash', payout, 'atm-robbery')
    exports['rp-dispatch']:CreateIncident('atm_robbery', 'ATM Robbery', coords, Player.PlayerData.citizenid)
end)

RegisterNetEvent('rp-crime:server:bankRobbery', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    exports['rp-dispatch']:CreateIncident('bank_robbery', 'Bank Robbery In Progress', coords, Player.PlayerData.citizenid)
    if exports.ox_inventory:GetItemCount(src, 'thermite') < 1 or exports.ox_inventory:GetItemCount(src, 'usb_hack') < 1 then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'Missing equipment', type = 'error' })
        return
    end
    exports.ox_inventory:RemoveItem(src, 'thermite', 1)
    exports.ox_inventory:RemoveItem(src, 'usb_hack', 1)
    local payout = math.random(45000, 140000)
    Player.Functions.AddMoney('cash', payout, 'bank-robbery')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Bank', description = 'Got away with $' .. payout, type = 'success' })
end)

RegisterNetEvent('rp-crime:server:placeBounty', function(targetCitizenId, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or amount < 5000 then return end
    if Player.PlayerData.money.bank < amount then return end
    Player.Functions.RemoveMoney('bank', amount, 'bounty')
    MySQL.insert('INSERT INTO rp_darkweb_bounties (poster_citizenid, target_citizenid, amount) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid, targetCitizenId, amount
    })
end)
