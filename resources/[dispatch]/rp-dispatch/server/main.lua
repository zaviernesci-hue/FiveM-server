--[[ rp-dispatch server - create incidents, persist to DB, broadcast to jobs ]]

local QBCore = exports['qb-core']:GetCoreObject()
local ActiveIncidents = {}

local function broadcastToJob(jobNames, incident)
    local players = QBCore.Functions.GetQBPlayers()
    for _, Player in pairs(players) do
        local job = Player.PlayerData.job
        if job and job.onduty then
            for _, jn in ipairs(jobNames) do
                if job.name == jn then
                    TriggerClientEvent('rp-dispatch:client:newIncident', Player.PlayerData.source, incident)
                    break
                end
            end
        end
    end
end

--- Create dispatch incident (exported)
function CreateIncident(incidentType, title, coords, callerCitizenId, extraData)
    local cfg = Incidents.Types[incidentType]
    if not cfg then return nil end
    local id = MySQL.insert.await('INSERT INTO rp_dispatch_logs (incident_type, title, coords, caller_citizenid, assigned_job, data) VALUES (?, ?, ?, ?, ?, ?)', {
        incidentType,
        title or cfg.label,
        json.encode({ x = coords.x, y = coords.y, z = coords.z }),
        callerCitizenId,
        cfg.jobs[1],
        extraData and json.encode(extraData) or nil,
    })
    local incident = {
        id = id,
        type = incidentType,
        title = title or cfg.label,
        coords = coords,
        jobs = cfg.jobs,
        blip = cfg.blip,
        color = cfg.color,
        status = 'open',
        data = extraData or {},
        createdAt = os.time(),
    }
    ActiveIncidents[id] = incident
    broadcastToJob(cfg.jobs, incident)
    return id
end
exports('CreateIncident', CreateIncident)

function CloseIncident(id)
    ActiveIncidents[id] = nil
    MySQL.update('UPDATE rp_dispatch_logs SET status = ? WHERE id = ?', { 'closed', id })
end
exports('CloseIncident', CloseIncident)

lib.callback.register('rp-dispatch:getActive', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return {} end
    local job = Player.PlayerData.job.name
    local list = {}
    for _, inc in pairs(ActiveIncidents) do
        for _, j in ipairs(inc.jobs) do
            if j == job then list[#list+1] = inc break end
        end
    end
    return list
end)

RegisterNetEvent('rp-dispatch:server:panic', function()
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= 'police' then return end
    CreateIncident('panic', 'Officer Panic - ' .. (Player.PlayerData.charinfo.firstname or ''), coords, Player.PlayerData.citizenid, { officer = src })
end)

RegisterNetEvent('rp-dispatch:server:911', function(message)
    local src = source
    local coords = GetEntityCoords(GetPlayerPed(src))
    local Player = QBCore.Functions.GetPlayer(src)
    CreateIncident('911', message or '911 Emergency', coords, Player and Player.PlayerData.citizenid, { message = message })
end)
