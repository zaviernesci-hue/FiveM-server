local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-phone:server:sendMessage', function(receiver, message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not message or #message > 500 then return end

    receiver = tostring(receiver or '')
    message = string.gsub(message, '%s+', ' ')
    if receiver == '' then return end

    local sender = Player.PlayerData.charinfo.phone or '5550000'
    MySQL.insert('INSERT INTO rp_phone_messages (sender, receiver, message) VALUES (?, ?, ?)', { sender, receiver, message })
    local players = QBCore.Functions.GetQBPlayers()
    for _, P in pairs(players) do
        if (P.PlayerData.charinfo.phone or '') == receiver then
            TriggerClientEvent('rp-phone:client:newMessage', P.PlayerData.source, { sender = sender, message = message })
        end
    end
end)

lib.callback.register('rp-phone:getMessages', function(source)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return {} end
    local num = P.PlayerData.charinfo.phone or ''
    return MySQL.query.await('SELECT * FROM rp_phone_messages WHERE sender = ? OR receiver = ? ORDER BY created_at DESC LIMIT 50', { num, num }) or {}
end)

lib.callback.register('rp-phone:getContacts', function(source)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return {} end
    return MySQL.query.await('SELECT * FROM rp_phone_contacts WHERE citizenid = ?', { P.PlayerData.citizenid }) or {}
end)

RegisterNetEvent('rp-phone:server:addContact', function(name, number)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return end
    MySQL.insert('INSERT INTO rp_phone_contacts (citizenid, name, number) VALUES (?, ?, ?)', { P.PlayerData.citizenid, name, number })
end)

-- TakTik
RegisterNetEvent('rp-phone:server:postTakTik', function(caption, videoUrl)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return end
    MySQL.insert('INSERT INTO rp_taktik_posts (citizenid, username, caption, video_url) VALUES (?, ?, ?, ?)', {
        P.PlayerData.citizenid, P.PlayerData.charinfo.firstname or 'user', caption, videoUrl
    })
end)

lib.callback.register('rp-phone:getTakTikFeed', function(_, tab)
    if tab == 'trending' then
        return MySQL.query.await('SELECT * FROM rp_taktik_posts ORDER BY likes DESC, views DESC LIMIT 30') or {}
    end
    return MySQL.query.await('SELECT * FROM rp_taktik_posts ORDER BY created_at DESC LIMIT 30') or {}
end)

RegisterNetEvent('rp-phone:server:likePost', function(postId)
    MySQL.update('UPDATE rp_taktik_posts SET likes = likes + 1 WHERE id = ?', { postId })
end)

RegisterNetEvent('rp-phone:server:commentPost', function(postId, comment)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return end
    MySQL.insert('INSERT INTO rp_taktik_comments (post_id, citizenid, comment) VALUES (?, ?, ?)', { postId, P.PlayerData.citizenid, comment })
end)

-- Dark web purchase
RegisterNetEvent('rp-phone:server:buyDarkWeb', function(item, price)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not item or not price or P.PlayerData.money.bank < price then
        return
    end
    P.Functions.RemoveMoney('bank', price, 'darkweb')
    exports.ox_inventory:AddItem(src, item, 1)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Dark Web', description = 'Purchased ' .. item, type = 'success' })
end)

RegisterNetEvent('rp-phone:server:buyBlackMarket', function(item, price)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not item or not price or P.PlayerData.money.cash < price then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Black Market', description = 'Not enough cash.', type = 'error' })
        return
    end
    P.Functions.RemoveMoney('cash', price, 'blackmarket')
    exports.ox_inventory:AddItem(src, item, 1)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Black Market', description = 'Purchased ' .. item, type = 'success' })
end)

lib.callback.register('rp-phone:getInventory', function(source)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then
        return { items = {}, usedSlots = 0, maxSlots = 50 }
    end
    local items = {}
    local usedSlots = 0
    for _, item in pairs(P.PlayerData.items or {}) do
        if item.amount and item.amount > 0 then
            table.insert(items, {
                name = item.name,
                label = item.label or item.name,
                amount = item.amount,
                slot = item.slot or 0,
            })
            usedSlots = usedSlots + 1
        end
    end
    return { items = items, usedSlots = usedSlots, maxSlots = 50 }
end)

lib.callback.register('rp-phone:canUseBank', function(source)
    local P = QBCore.Functions.GetPlayer(source)
    if not P then return false end
    return exports.ox_inventory:GetItemCount(source, 'bank_card') > 0
end)
