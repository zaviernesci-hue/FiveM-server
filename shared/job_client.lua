--[[ Shared job client helpers - duty toggle, vehicle spawn, job payout tasks ]]

JobClient = {}

function JobClient.GetJob()
    return exports['qb-core']:GetCoreObject().Functions.GetPlayerData().job
end

function JobClient.IsJob(name)
    local job = JobClient.GetJob()
    return job and job.name == name
end

function JobClient.IsOnDuty(name)
    local job = JobClient.GetJob()
    return job and job.name == name and job.onduty
end

function JobClient.ToggleDuty()
    TriggerServerEvent('QBCore:ToggleDuty')
end

function JobClient.SpawnVehicle(model, coords)
    lib.requestModel(model)
    local c = coords or GetEntityCoords(PlayerPedId())
    local h = coords and coords.w or GetEntityHeading(PlayerPedId())
    local veh = CreateVehicle(joaat(model), c.x, c.y, c.z, h, true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    return veh
end

function JobClient.AddDutyZone(jobName, coords, label)
    exports.ox_target:addSphereZone({
        coords = coords, radius = 1.5,
        options = {{
            name = jobName .. '_duty',
            icon = 'fas fa-briefcase',
            label = label or 'Toggle Duty',
            canInteract = function() return JobClient.IsJob(jobName) end,
            onSelect = function() JobClient.ToggleDuty() end,
        }},
    })
end

function JobClient.DoTimedTask(duration, label, onComplete)
    if lib.progressBar({ duration = duration, label = label, canCancel = true, disable = { move = true, car = true } }) then
        if onComplete then onComplete() end
        return true
    end
    return false
end

function JobClient.PayTaskEvent(eventName, amountKey)
    TriggerServerEvent(eventName, amountKey)
end
