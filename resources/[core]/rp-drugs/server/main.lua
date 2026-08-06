local QBCore = exports['qb-core']:GetCoreObject()

local DrugData = {
    weed = { label = 'Weed', produceCost = 1250, minSell = 2800, maxSell = 4200 },
    meth = { label = 'Meth', produceCost = 2400, minSell = 6200, maxSell = 7800 },
}

local function notify(src, title, description, type)
    TriggerClientEvent('ox_lib:notify', src, { title = title, description = description, type = type })
end

local function getDrugStock(player)
    local stock = player.PlayerData.metadata.drugs
    if type(stock) ~= 'table' then
        stock = {}
    end
    return stock
end

local function setDrugStock(player, stock)
    player.Functions.SetMetaData('drugs', stock)
end

RegisterNetEvent('rp-drugs:server:produce', function(drugType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local drug = DrugData[drugType]
    if not drug then return end

    if Player.PlayerData.money.cash < drug.produceCost then
        return notify(src, 'Drug Lab', 'Not enough cash for supplies.', 'error')
    end

    Player.Functions.RemoveMoney('cash', drug.produceCost, 'drug-production')
    local producedAmount = math.random(1, 3)
    local stock = getDrugStock(Player)
    stock[drugType] = (stock[drugType] or 0) + producedAmount
    setDrugStock(Player, stock)

    notify(src, 'Drug Lab', string.format('Produced %s x%d. Sell it at the street market.', drug.label, producedAmount), 'success')
end)

RegisterNetEvent('rp-drugs:server:sell', function(drugType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local drug = DrugData[drugType]
    if not drug then return end

    local stock = getDrugStock(Player)
    local count = stock[drugType] or 0
    if count <= 0 then
        return notify(src, 'Drug Lab', 'You have no product to sell.', 'error')
    end

    stock[drugType] = count - 1
    setDrugStock(Player, stock)
    local payout = math.random(drug.minSell, drug.maxSell)
    Player.Functions.AddMoney('cash', payout, 'drug-sale')

    notify(src, 'Drug Lab', string.format('Sold 1 %s package for $%s.', drug.label, payout), 'success')
end)

QBCore.Functions.CreateCallback('rp-drugs:server:getStock', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then cb({}) return end
    cb(getDrugStock(Player))
end)
