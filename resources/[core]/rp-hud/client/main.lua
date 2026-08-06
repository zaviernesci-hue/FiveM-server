--[[ rp-hud client - sends player stats to NUI every frame (optimized interval) ]]

local QBCore = exports['qb-core']:GetCoreObject()
local seatbelt = false
local talking = false

--- Toggle seatbelt (B key default)
RegisterCommand('seatbelt', function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end
    seatbelt = not seatbelt
    lib.notify({ title = 'Seatbelt', description = seatbelt and 'Buckled' or 'Unbuckled', type = 'inform' })
end, false)
RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', 'B')

--- Voice talking indicator (pma-voice)
AddEventHandler('pma-voice:setTalkingMode', function() end)
RegisterNetEvent('pma-voice:radioActive', function(t) talking = t end)

CreateThread(function()
    while true do
        local sleep = 200
        local ped = PlayerPedId()
        local player = QBCore.Functions.GetPlayerData()
        if player and player.citizenid then
            sleep = 100
            local health = GetEntityHealth(ped) - 100
            local armor = GetPedArmour(ped)
            local hunger = player.metadata and player.metadata.hunger or 100
            local thirst = player.metadata and player.metadata.thirst or 100
            local stress = player.metadata and player.metadata.stress or 0
            local cash = player.money and player.money.cash or 0
            local bank = player.money and player.money.bank or 0
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local streetHash, crossingHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local street = GetStreetNameFromHashKey(streetHash)
            local speed = 0
            local fuel = 100
            local inVeh = IsPedInAnyVehicle(ped, false)
            if inVeh then
                local veh = GetVehiclePedIsIn(ped, false)
                speed = math.ceil(GetEntitySpeed(veh) * 2.236936)
                fuel = exports['rp-fuel']:GetFuel(veh) or 100
            end
            local compass = 'N'
            if heading >= 45 and heading < 135 then compass = 'E'
            elseif heading >= 135 and heading < 225 then compass = 'S'
            elseif heading >= 225 and heading < 315 then compass = 'W' end
            SendNUIMessage({
                action = 'update',
                health = health, armor = armor,
                hunger = hunger, thirst = thirst, stress = stress,
                cash = cash, bank = bank,
                fuel = fuel, speed = speed, compass = compass,
                street = street, seatbelt = seatbelt,
                talking = NetworkIsPlayerTalking(PlayerId()),
                inVehicle = inVeh,
            })
        end
        Wait(sleep)
    end
end)

-- Hide default HUD components
CreateThread(function()
    local hide = { 1, 2, 3, 4, 6, 7, 8, 9, 13, 14, 19, 20, 21, 22 }
    while true do
        for _, id in ipairs(hide) do HideHudComponentThisFrame(id) end
        Wait(0)
    end
end)
