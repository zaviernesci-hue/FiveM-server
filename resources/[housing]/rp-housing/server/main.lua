local QBCore = exports['qb-core']:GetCoreObject()

Properties = {
    { id = 'apartment_1', label = 'South LS Apt', coords = vector3(265.89, -1003.2, 29.29), price = 85000, rent = 1200 },
    { id = 'apartment_2', label = 'Downtown Loft', coords = vector3(309.7, -594.8, 43.3), price = 95000, rent = 1400 },
    { id = 'house_mirror_park', label = 'Mirror Park House', coords = vector3(1300.2, -574.5, 71.73), price = 425000, rent = 0 },
    { id = 'house_vinewood', label = 'Vinewood Mansion', coords = vector3(340.2, 437.9, 149.4), price = 890000, rent = 0 },
    { id = 'house_sandy', label = 'Sandy Shores House', coords = vector3(1966.0, 3818.4, 32.3), price = 175000, rent = 0 },
    { id = 'house_lossoques', label = 'Los Santos House', coords = vector3(-1817.4, 799.0, 138.5), price = 560000, rent = 0 },
}

lib.callback.register('rp-housing:getProperties', function()
    return MySQL.query.await('SELECT * FROM rp_housing') or {}
end)

RegisterNetEvent('rp-housing:server:buy', function(propertyId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P then return end
    local prop = MySQL.single.await('SELECT * FROM rp_housing WHERE property_id = ?', { propertyId })
    if not prop or prop.owned == 1 then return end
    if P.PlayerData.money.bank < prop.purchase_price then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Housing', description = 'Insufficient funds', type = 'error' })
        return
    end
    P.Functions.RemoveMoney('bank', prop.purchase_price, 'house-purchase')
    MySQL.update('UPDATE rp_housing SET owner_citizenid = ?, owned = 1 WHERE property_id = ?', { P.PlayerData.citizenid, propertyId })
end)

RegisterNetEvent('rp-housing:server:giveKey', function(propertyId, targetId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    local T = QBCore.Functions.GetPlayer(tonumber(targetId))
    if not P or not T then return end
    local prop = MySQL.single.await('SELECT * FROM rp_housing WHERE property_id = ? AND owner_citizenid = ?', { propertyId, P.PlayerData.citizenid })
    if not prop then return end
    local keys = json.decode(prop.keys or '[]')
    keys[#keys+1] = T.PlayerData.citizenid
    MySQL.update('UPDATE rp_housing SET `keys` = ? WHERE property_id = ?', { json.encode(keys), propertyId })
end)
