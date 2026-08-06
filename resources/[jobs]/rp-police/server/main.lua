local QBCore = exports['qb-core']:GetCoreObject()

local function isPolice(src)
    local P = QBCore.Functions.GetPlayer(src)
    return P and P.PlayerData.job.name == 'police'
end

RegisterNetEvent('rp-police:server:toggleDuty', function()
    local src = source
    if not isPolice(src) then return end
    local P = QBCore.Functions.GetPlayer(src)
    P.Functions.SetJobDuty(not P.PlayerData.job.onduty)
end)

RegisterNetEvent('rp-police:server:panic', function()
    TriggerEvent('rp-dispatch:server:panic')
end)

RegisterNetEvent('rp-police:server:storeEvidence', function(caseNumber, items)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not P.PlayerData.job.onduty then return end
    MySQL.insert('INSERT INTO rp_evidence (locker_id, case_number, officer_citizenid, items) VALUES (?, ?, ?, ?)', {
        'mrpd', caseNumber, P.PlayerData.citizenid, json.encode(items)
    })
end)

RegisterNetEvent('rp-police:server:cuff', function(targetId)
    local src = source
    if not isPolice(src) then return end
    TriggerClientEvent('rp-police:client:getCuffed', tonumber(targetId))
end)

RegisterNetEvent('rp-police:server:giveArmoryItem', function(item)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or not P.PlayerData.job.onduty then return end
    exports.ox_inventory:AddItem(src, item, 1)
end)
