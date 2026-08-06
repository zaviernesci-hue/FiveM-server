--[[ rp-dispatch client - tablet UI for police, taxi panel, GPS routes ]]

local QBCore = exports['qb-core']:GetCoreObject()
local incidents = {}
local tabletOpen = false

RegisterNetEvent('rp-dispatch:client:newIncident', function(incident)
    incidents[incident.id] = incident
    if tabletOpen then SendNUIMessage({ action = 'incidents', list = GetIncidentList() }) end
    lib.notify({ title = 'Dispatch', description = incident.title, type = 'inform' })
    -- Blip
    local blip = AddBlipForCoord(incident.coords.x, incident.coords.y, incident.coords.z)
    SetBlipSprite(blip, incident.blip or 480)
    SetBlipColour(blip, incident.color or 1)
    SetBlipScale(blip, 0.9)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(incident.title)
    EndTextCommandSetBlipName(blip)
    SetTimeout(120000, function() RemoveBlip(blip) end)
end)

function GetIncidentList()
    local list = {}
    for _, v in pairs(incidents) do list[#list+1] = v end
    return list
end

--- Police MDT tablet (side panel)
RegisterCommand('mdt', function()
    local job = QBCore.Functions.GetPlayerData().job
    if not job or job.name ~= 'police' or not job.onduty then return end
    tabletOpen = not tabletOpen
    SetNuiFocus(tabletOpen, tabletOpen)
    SendNUIMessage({ action = tabletOpen and 'openTablet' or 'close', list = GetIncidentList() })
end, false)
RegisterKeyMapping('mdt', 'Open Police MDT', 'keyboard', 'T')

RegisterNUICallback('setGPS', function(data, cb)
    if data.coords then SetNewWaypoint(data.coords.x, data.coords.y) end
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    tabletOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

--- Taxi dispatch panel
RegisterNetEvent('rp-dispatch:client:taxiJob', function(job)
    SendNUIMessage({ action = 'taxiJob', job = job })
end)

exports('RequestTaxi', function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('rp-dispatch:server:requestTaxi', coords)
end)
