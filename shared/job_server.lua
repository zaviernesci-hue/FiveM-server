--[[ Shared job server helpers - task payouts to BANK (jobs also get hourly via rp-core) ]]

local QBCore = exports['qb-core']:GetCoreObject()

JobServer = {}

function JobServer.IsJob(src, jobName)
    local P = QBCore.Functions.GetPlayer(src)
    return P and P.PlayerData.job.name == jobName
end

function JobServer.PayBank(src, amount, reason)
    local P = QBCore.Functions.GetPlayer(src)
    if not P or amount <= 0 then return false end
    P.Functions.AddMoney('bank', amount, reason or 'job-task')
    TriggerClientEvent('ox_lib:notify', src, { title = 'Payment', description = '$' .. amount .. ' deposited to bank', type = 'success' })
    return true
end

function JobServer.RegisterTaskPay(eventName, jobName, minPay, maxPay)
    RegisterNetEvent(eventName, function()
        local src = source
        if not JobServer.IsJob(src, jobName) then return end
        local pay = math.random(minPay, maxPay)
        JobServer.PayBank(src, pay, jobName .. '-task')
    end)
end
