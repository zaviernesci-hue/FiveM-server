local QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('rp-licences:hasLicence', function(source, licenceType)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local r = MySQL.scalar.await('SELECT id FROM rp_licences WHERE citizenid = ? AND licence_type = ? AND status = ?', {
        Player.PlayerData.citizenid, licenceType, 'valid'
    })
    return r ~= nil
end)

RegisterNetEvent('rp-licences:server:buyTest', function(testType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local cost = testType == 'theory' and 250 or 500
    if Player.PlayerData.money.bank < cost then
        TriggerClientEvent('ox_lib:notify', src, { title = 'DMV', description = 'Insufficient funds', type = 'error' })
        return
    end
    Player.Functions.RemoveMoney('bank', cost, 'dmv-' .. testType)
    TriggerClientEvent('rp-licences:client:startTest', src, testType)
end)

RegisterNetEvent('rp-licences:server:passTest', function(testType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if testType == 'driving' then
        MySQL.insert('INSERT INTO rp_licences (citizenid, licence_type, status) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE status = ?', {
            Player.PlayerData.citizenid, 'driver', 'valid', 'valid'
        })
        TriggerClientEvent('ox_lib:notify', src, { title = 'DMV', description = 'Driver licence issued!', type = 'success' })
    end
end)

RegisterNetEvent('rp-licences:server:fineNoLicence', function(targetId)
    local src = source
    local Officer = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not Officer or Officer.PlayerData.job.name ~= 'police' then return end
    if not Target then return end
    local has = MySQL.scalar.await('SELECT id FROM rp_licences WHERE citizenid = ? AND licence_type = driver AND status = valid', { Target.PlayerData.citizenid })
    if has then return end
    Target.Functions.RemoveMoney('bank', 1500, 'fine-no-licence')
    TriggerClientEvent('ox_lib:notify', Target.PlayerData.source, { title = 'Citation', description = 'Driving without licence — $1500', type = 'error' })
end)
