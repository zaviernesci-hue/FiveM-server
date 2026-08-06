local QBCore = exports['qb-core']:GetCoreObject()
local cuffed = false

local function isOnDutyPolice()
    local job = QBCore.Functions.GetPlayerData().job
    return job and job.name == 'police' and job.onduty
end

local function getRankVehicles()
    local job = QBCore.Functions.GetPlayerData().job
    local grade = (job and job.grade and job.grade.level) or (job and job.grade) or 0
    grade = tonumber(grade) or 0
    local allowed = Config.RankVehicles and Config.RankVehicles[grade]
    if not allowed or #allowed == 0 then allowed = Config.RankVehicles and Config.RankVehicles[0] or { { model = 'police', label = 'Patrol Cruiser', speed = 110 } } end
    return allowed
end

local function getVehicleLabel(vehicle)
    if type(vehicle) == 'table' then
        return vehicle.label or vehicle.model or 'Vehicle'
    end
    return vehicle
end

-- Duty point
CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = Config.Duty, radius = 1.5,
        options = {{
            name = 'pd_duty', icon = 'fas fa-id-badge', label = 'Toggle Duty',
            canInteract = function() return QBCore.Functions.GetPlayerData().job.name == 'police' end,
            onSelect = function() TriggerServerEvent('rp-police:server:toggleDuty') end,
        }},
    })
    exports.ox_target:addSphereZone({
        coords = Config.Armory, radius = 1.5,
        options = {{
            name = 'pd_armory', icon = 'fas fa-gun', label = 'Armory',
            canInteract = isOnDutyPolice,
            onSelect = function()
                lib.registerContext({
                    id = 'pd_armory',
                    title = 'Armory',
                    options = {
                        { title = 'Handcuffs', onSelect = function() TriggerServerEvent('rp-police:server:giveArmoryItem', 'handcuffs') end },
                        { title = 'Taser', onSelect = function() TriggerServerEvent('rp-police:server:giveArmoryItem', 'weapon_stungun') end },
                        { title = 'Spike Strips', onSelect = function() TriggerServerEvent('rp-police:server:giveArmoryItem', 'spikestrip') end },
                        { title = 'Radar Gun', onSelect = function() TriggerServerEvent('rp-police:server:giveArmoryItem', 'radar_gun') end },
                    },
                })
                lib.showContext('pd_armory')
            end,
        }},
    })
    exports.ox_target:addSphereZone({
        coords = Config.Garage.xyz, radius = 3.0,
        options = {{
            name = 'pd_garage', icon = 'fas fa-car', label = 'Police Garage',
            canInteract = isOnDutyPolice,
            onSelect = function()
                local options = {}
                for _, vehicle in ipairs(getRankVehicles()) do
                    options[#options + 1] = { title = getVehicleLabel(vehicle), onSelect = function() spawnJobVeh(vehicle) end }
                end
                options[#options + 1] = { title = 'Helicopter', onSelect = function() spawnJobVeh(Config.HeliModel, Config.Heli) end }
                lib.registerContext({
                    id = 'pd_garage',
                    title = 'Garage',
                    options = options,
                })
                lib.showContext('pd_garage')
            end,
        }},
    })
end)

function spawnJobVeh(vehicle, coords)
    coords = coords or Config.Garage
    local model = type(vehicle) == 'table' and vehicle.model or vehicle
    local speed = type(vehicle) == 'table' and vehicle.speed or 110

    lib.requestModel(model)
    local veh = CreateVehicle(joaat(model), coords.x, coords.y, coords.z, coords.w, true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetVehicleNumberPlateText(veh, 'LSPD' .. math.random(100,999))
    SetVehicleMaxSpeed(veh, speed / 2.236936)
    SetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel', speed / 2.236936)
end

-- Handcuffs
RegisterNetEvent('rp-police:client:getCuffed', function()
    cuffed = not cuffed
    local ped = PlayerPedId()
    if cuffed then
        lib.requestAnimDict('mp_arresting')
        TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, false, false, false)
    else ClearPedTasks(ped) end
end)

RegisterCommand('cuff', function(_, args)
    if not isOnDutyPolice() then return end
    local id = tonumber(args[1])
    if id then TriggerServerEvent('rp-police:server:cuff', id) end
end)

RegisterCommand('panic', function()
    if not isOnDutyPolice() then return end
    TriggerServerEvent('rp-dispatch:server:panic')
    lib.notify({ title = 'PANIC', description = 'Panic button activated!', type = 'error' })
end)

-- Outfit locker (duty uniforms only)
RegisterNetEvent('rp-police:client:locker', function()
    if not isOnDutyPolice() then
        lib.notify({ title = 'Locker', description = 'Go on duty first', type = 'error' })
        return
    end
    TriggerEvent('illenium-appearance:client:openOutfitMenu')
end)

-- Speed radar
RegisterCommand('radar', function()
    if not isOnDutyPolice() then return end
    local veh = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 30.0, false)
    if veh then
        local speed = math.ceil(GetEntitySpeed(veh) * 2.236936)
        lib.notify({ title = 'Radar', description = 'Speed: ' .. speed .. ' MPH', type = 'inform' })
    end
end)
