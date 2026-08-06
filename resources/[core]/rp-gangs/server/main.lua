local QBCore = exports['qb-core']:GetCoreObject()

local GangTerritories = {
    { name = 'Vespucci Canals', coords = vector3(338.0, -2044.0, 21.0), controllingGang = nil, takeoverCost = 1500 },
    { name = 'Davis Blocks', coords = vector3(133.0, -1924.0, 23.0), controllingGang = nil, takeoverCost = 1800 },
    { name = 'Paleto Bay', coords = vector3(-102.0, 6484.0, 31.6), controllingGang = nil, takeoverCost = 2200 },
}

local function notify(src, title, description, type)
    TriggerClientEvent('ox_lib:notify', src, { title = title, description = description, type = type })
end

RegisterNetEvent('rp-gangs:server:join', function(gangName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData('gang', gangName)
    notify(src, 'Gang', 'You joined the ' .. gangName .. ' crew.', 'success')
end)

RegisterNetEvent('rp-gangs:server:leave', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.SetMetaData('gang', nil)
    notify(src, 'Gang', 'You left your crew.', 'inform')
end)

RegisterNetEvent('rp-gangs:server:claimTerritory', function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local gangName = Player.PlayerData.metadata.gang
    if not gangName then
        return notify(src, 'Gang', 'Join a crew before claiming territory.', 'error')
    end

    local territory = GangTerritories[index]
    if not territory then
        return notify(src, 'Gang', 'Territory not found.', 'error')
    end

    if territory.controllingGang == gangName then
        return notify(src, 'Gang', territory.name .. ' is already controlled by your crew.', 'inform')
    end

    if territory.controllingGang then
        if Player.PlayerData.money.cash < territory.takeoverCost then
            return notify(src, 'Gang', 'You need $' .. territory.takeoverCost .. ' cash to take over this territory.', 'error')
        end
        Player.Functions.RemoveMoney('cash', territory.takeoverCost, 'gang-takeover')
        territory.controllingGang = gangName
        return notify(src, 'Gang', 'You took over ' .. territory.name .. ' for ' .. gangName .. '.', 'success')
    end

    territory.controllingGang = gangName
    notify(src, 'Gang', 'Your crew now controls ' .. territory.name .. '.', 'success')
end)

RegisterNetEvent('rp-gangs:server:collectIncome', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local gangName = Player.PlayerData.metadata.gang
    if not gangName then
        return notify(src, 'Gang', 'You must be part of a crew to collect income.', 'error')
    end

    local payout = 0
    for _, territory in ipairs(GangTerritories) do
        if territory.controllingGang == gangName then
            payout = payout + math.floor(territory.takeoverCost * 1.5)
        end
    end

    if payout <= 0 then
        return notify(src, 'Gang', 'Your crew does not control any territory yet.', 'inform')
    end

    Player.Functions.AddMoney('bank', payout, 'gang-income')
    notify(src, 'Gang', 'Collected gang territory income: $' .. payout, 'success')
end)

QBCore.Functions.CreateCallback('rp-gangs:server:getTerritoryInfo', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local gangName = Player and Player.PlayerData.metadata.gang or nil
    cb({ gang = gangName, territories = GangTerritories })
end)
