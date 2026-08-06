local QBCore = exports['qb-core']:GetCoreObject()
local FEE = 0.05

lib.callback.register('rp-marketplace:getListings', function()
    return MySQL.query.await("SELECT * FROM rp_marketplace WHERE status = 'active' ORDER BY created_at DESC LIMIT 50") or {}
end)

RegisterNetEvent('rp-marketplace:server:createListing', function(data)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not data or type(data) ~= 'table' then return end
    if not data.price or data.price < 1 then return end
    if data.item_name and exports.ox_inventory:GetItemCount(src, data.item_name) < (data.item_amount or 1) then return end
    if data.item_name then exports.ox_inventory:RemoveItem(src, data.item_name, data.item_amount or 1) end
    MySQL.insert('INSERT INTO rp_marketplace (seller_citizenid, title, description, item_name, item_amount, vehicle_plate, price, listing_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        P.PlayerData.citizenid, data.title or 'Listing', data.description or '', data.item_name, data.item_amount or 1, data.vehicle_plate, data.price, data.listing_type or 'buy_now'
    })
end)

RegisterNetEvent('rp-marketplace:server:buy', function(listingId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    local listing = MySQL.single.await('SELECT * FROM rp_marketplace WHERE id = ? AND status = ?', { listingId, 'active' })
    if not P or not listing or listing.seller_citizenid == P.PlayerData.citizenid then return end
    if P.PlayerData.money.bank < listing.price then return end
    P.Functions.RemoveMoney('bank', listing.price, 'marketplace-buy')
    local fee = math.floor(listing.price * FEE)
    local seller = QBCore.Functions.GetPlayerByCitizenId(listing.seller_citizenid)
    if seller then
        seller.Functions.AddMoney('bank', listing.price - fee, 'marketplace-sell')
    else
        -- offline seller payout stored in DB could be added
    end
    if listing.item_name then exports.ox_inventory:AddItem(src, listing.item_name, listing.item_amount or 1) end
    MySQL.update("UPDATE rp_marketplace SET status = 'sold' WHERE id = ?", { listingId })
end)

RegisterNetEvent('rp-marketplace:server:bid', function(listingId, amount)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or amount <= 0 then return end
    local listing = MySQL.single.await('SELECT * FROM rp_marketplace WHERE id = ? AND listing_type = ?', { listingId, 'auction' })
    if not listing or amount <= listing.current_bid then return end
    MySQL.update('UPDATE rp_marketplace SET current_bid = ?, bidder_citizenid = ? WHERE id = ?', { amount, P.PlayerData.citizenid, listingId })
end)

RegisterNetEvent('rp-marketplace:server:cancel', function(listingId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    local listing = MySQL.single.await('SELECT * FROM rp_marketplace WHERE id = ? AND seller_citizenid = ?', { listingId, P.PlayerData.citizenid })
    if not listing then return end
    if listing.item_name then exports.ox_inventory:AddItem(src, listing.item_name, listing.item_amount or 1) end
    MySQL.update("UPDATE rp_marketplace SET status = 'cancelled' WHERE id = ?", { listingId })
end)
