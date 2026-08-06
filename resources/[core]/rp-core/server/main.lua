--[[ rp-core server - paycheck system, money helpers, QBCore bridge ]]

local QBCore = exports['qb-core']:GetCoreObject()

Config = Config or {
    ServerName = 'Los Santos Roleplay',
    StartingCash = 500,
    StartingBank = 2500,
    PaycheckIntervalMinutes = 60,
    TaxRate = 0.05,
    EmergencyJobs = { 'police', 'ambulance', 'fire' },
    StarterVehicle = { model = 'faggio2', garage = 'pillboxgarage' },
}

JobsConfig = JobsConfig or { List = {} }
VehiclesConfig = VehiclesConfig or { Catalog = {}, Dealerships = {} }

--- Export: get server config
exports('GetConfig', function() return Config end)
exports('GetJobs', function() return JobsConfig end)
exports('GetVehicles', function() return VehiclesConfig or {} end)

CreateThread(function()
    Wait(1000)
    print(('[rp-core] Loaded config for %s with %d jobs and %d vehicles'):format(Config.ServerName or 'Unknown', (JobsConfig.List and table.length(JobsConfig.List)) or 0, (VehiclesConfig.Catalog and #VehiclesConfig.Catalog) or 0))
end)

--- Get citizenid from player source
exports('GetPlayerCitizenId', function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.PlayerData.citizenid or nil
end)

--- Add money to bank with transaction log
exports('AddBankMoney', function(src, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or amount <= 0 then return false end
    Player.Functions.AddMoney('bank', amount, reason or 'rp-core')
    exports['rp-banking']:LogTransaction(Player.PlayerData.citizenid, 'deposit', amount, reason)
    return true
end)

--- Remove bank money
exports('RemoveBankMoney', function(src, amount, reason)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or amount <= 0 then return false end
    if Player.PlayerData.money.bank < amount then return false end
    Player.Functions.RemoveMoney('bank', amount, reason or 'rp-core')
    exports['rp-banking']:LogTransaction(Player.PlayerData.citizenid, 'withdraw', -amount, reason)
    return true
end)

--- Hourly paycheck loop — pays to BANK account
CreateThread(function()
    local interval = (Config.PaycheckIntervalMinutes or 60) * 60000
    while true do
        Wait(interval)
        local players = QBCore.Functions.GetQBPlayers()
        for _, Player in pairs(players) do
            local job = Player.PlayerData.job
            if job and job.name then
                local jobCfg = JobsConfig.List[job.name]
                if jobCfg then
                    local onDuty = job.onduty
                    if onDuty or jobCfg.offDutyPay then
                        local grade = job.grade and job.grade.level or 0
                        local pay = jobCfg.grades[grade] and jobCfg.grades[grade].payment or jobCfg.hourlyPay or 0
                        if pay > 0 then
                            local tax = math.floor(pay * (Config.TaxRate or 0))
                            local net = pay - tax
                            Player.Functions.AddMoney('bank', net, 'paycheck-' .. job.name)
                            MySQL.insert('INSERT INTO rp_paychecks (citizenid, job, amount, tax_deducted) VALUES (?, ?, ?, ?)', {
                                Player.PlayerData.citizenid, job.name, net, tax
                            })
                            TriggerClientEvent('ox_lib:notify', Player.PlayerData.source, {
                                title = 'Paycheck',
                                description = ('Received %s (tax: %s) — %s'):format('$' .. net, '$' .. tax, job.label or job.name),
                                type = 'success',
                            })
                        end
                    end
                end
            end
        end
    end
end)

--- Give starter moped on first spawn flag
RegisterNetEvent('rp-core:server:giveStarterVehicle', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local meta = Player.PlayerData.metadata
    if meta.starterVehicleGiven then return end
    local plate = 'RP' .. math.random(1000, 9999)
    local model = Config.StarterVehicle.model
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, plate, garage, fuel, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        model,
        joaat(model),
        plate,
        Config.StarterVehicle.garage or 'pillboxgarage',
        100,
        1,
    })
    meta.starterVehicleGiven = true
    Player.Functions.SetMetaData('starterVehicleGiven', true)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Welcome', description = 'Starter moped added to your garage!', type = 'inform' })
end)

print('[rp-core] Loaded — paycheck interval: ' .. (Config.PaycheckIntervalMinutes or 60) .. ' min')
