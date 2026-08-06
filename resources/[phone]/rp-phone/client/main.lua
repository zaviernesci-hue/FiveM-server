local QBCore = exports['qb-core']:GetCoreObject()
local phoneOpen = false
local phoneKey = 'P'
local inventoryKey = 'I'

local function registerPhoneKeybind()
    RegisterKeyMapping('phone', 'Open Phone', 'keyboard', phoneKey)
end

local function registerInventoryKeybind()
    RegisterKeyMapping('inventory', 'Open Inventory', 'keyboard', inventoryKey)
end

Citizen.CreateThread(function()
    phoneKey = GetResourceKvpString('rpPhoneKey') or 'P'
    inventoryKey = GetResourceKvpString('rpInventoryKey') or 'I'
    registerPhoneKeybind()
    registerInventoryKeybind()
end)

RegisterCommand('phone', function()
    phoneOpen = not phoneOpen
    SetNuiFocus(phoneOpen, phoneOpen)
    local p = QBCore.Functions.GetPlayerData()
    SendNUIMessage({
        action = phoneOpen and 'open' or 'close',
        apps = { 'messages','calls','contacts','camera','gallery','settings','calculator','maps','bank','vehicles','inventory','marketplace','business','contracts','casino','services','blackmarket','chrome','browser','darkweb' },
        player = { name = p.charinfo.firstname, bank = p.money.bank, cash = p.money.cash, darkBrowser = p.metadata.darkBrowser },
    })
end, false)

RegisterCommand('inventory', function()
    phoneOpen = true
    SetNuiFocus(true, true)
    local p = QBCore.Functions.GetPlayerData()
    SendNUIMessage({
        action = 'open',
        apps = { 'messages','calls','contacts','camera','gallery','settings','calculator','maps','bank','vehicles','inventory','marketplace','business','contracts','casino','services','blackmarket','chrome','browser','darkweb' },
        player = { name = p.charinfo.firstname, bank = p.money.bank, cash = p.money.cash, darkBrowser = p.metadata.darkBrowser },
    })
    SendNUIMessage({ action = 'openApp', app = 'inventory' })
end, false)

RegisterNUICallback('close', function(_, cb)
    phoneOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('getMessages', function(_, cb)
    lib.callback('rp-phone:getMessages', false, function(msgs) cb(msgs) end)
end)

RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('rp-phone:server:sendMessage', data.receiver, data.message)
    cb('ok')
end)

RegisterNUICallback('getTakTik', function(data, cb)
    lib.callback('rp-phone:getTakTikFeed', false, function(feed) cb(feed) end, data.tab or 'feed')
end)

RegisterNUICallback('likePost', function(data, cb)
    TriggerServerEvent('rp-phone:server:likePost', data.id)
    cb('ok')
end)

RegisterNUICallback('bankTransfer', function(data, cb)
    TriggerServerEvent('rp-banking:server:transfer', data.targetId, data.amount, data.note)
    cb('ok')
end)

RegisterNUICallback('openBrowser', function(data, cb)
    if data.url then SendNUIMessage({ action = 'browserUrl', url = data.url }) end
    cb('ok')
end)

RegisterNUICallback('buyDarkWeb', function(data, cb)
    TriggerServerEvent('rp-phone:server:buyDarkWeb', data.item, data.price)
    cb('ok')
end)

RegisterNUICallback('getInventory', function(_, cb)
    lib.callback('rp-phone:getInventory', false, function(data)
        cb(data)
    end)
end)

RegisterNUICallback('saveSettings', function(data, cb)
    if data.phoneKey then
        phoneKey = tostring(data.phoneKey):upper():sub(1, 1)
        if phoneKey == '' then phoneKey = 'P' end
        SetResourceKvpString('rpPhoneKey', phoneKey)
        registerPhoneKeybind()
    end
    if data.inventoryKey then
        inventoryKey = tostring(data.inventoryKey):upper():sub(1, 1)
        if inventoryKey == '' then inventoryKey = 'I' end
        SetResourceKvpString('rpInventoryKey', inventoryKey)
        registerInventoryKeybind()
    end
    cb('ok')
end)

RegisterNUICallback('buyBlackMarket', function(data, cb)
    TriggerServerEvent('rp-phone:server:buyBlackMarket', data.item, data.price)
    cb('ok')
end)

RegisterNUICallback('appAction', function(data, cb)
    local action = data.action
    if action == 'bank' then
        lib.callback('rp-phone:canUseBank', false, function(hasCard)
            if hasCard then
                TriggerEvent('rp-banking:client:openMenu')
            else
                lib.notify({ title = 'Bank', description = 'You need a bank card to use mobile banking.', type = 'error' })
            end
        end)
    elseif action == 'business' then
        TriggerEvent('rp-businesses:client:openMenu')
    elseif action == 'contracts' then
        TriggerEvent('rp-contracts:client:openBoard')
    elseif action == 'casino' then
        TriggerEvent('rp-casino:client:openTable')
    elseif action == 'services:bounty' then
        TriggerEvent('rp-bounties:client:openBoard')
    elseif action == 'services:drug' then
        TriggerEvent('rp-drugs:client:openLab')
    elseif action == 'marketplace' then
        TriggerEvent('rp-marketplace:client:openMenu')
    elseif action == 'inventory' then
        SendNUIMessage({ action = 'openApp', app = 'inventory' })
    elseif action == 'blackmarket' then
        SendNUIMessage({ action = 'openApp', app = 'blackmarket' })
    end
    cb('ok')
end)

RegisterNetEvent('rp-phone:client:newMessage', function(msg)
    if phoneOpen then SendNUIMessage({ action = 'newMessage', msg = msg }) end
    lib.notify({ title = 'New Message', description = msg.message, type = 'inform' })
end)

-- Phone calls via pma-voice
RegisterNUICallback('call', function(data, cb)
    exports['pma-voice']:setCallChannel(tonumber(data.number) or 0)
    cb('ok')
end)
