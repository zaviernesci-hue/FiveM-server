local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-ems:server:revive', function(targetId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or P.PlayerData.job.name ~= 'ambulance' or not P.PlayerData.job.onduty then return end
    TriggerClientEvent('rp-ems:client:revived', tonumber(targetId))
    JobServer = JobServer or {}
end)

RegisterNetEvent('rp-ems:server:heal', function(targetId)
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or P.PlayerData.job.name ~= 'ambulance' or not P.PlayerData.job.onduty then return end
    TriggerClientEvent('rp-ems:client:healed', tonumber(targetId))
end)

RegisterNetEvent('rp-ems:server:taskPay', function()
    local src = source
    local P = QBCore.Functions.GetPlayer(src)
    if not P or P.PlayerData.job.name ~= 'ambulance' then return end
    P.Functions.AddMoney('bank', math.random(75, 200), 'ems-call')
end)
