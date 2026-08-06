--[[ rp-needs client - decay hunger/thirst, stress on shooting ]]

local QBCore = exports['qb-core']:GetCoreObject()
local hunger, thirst, stress = 100, 100, 0

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local p = QBCore.Functions.GetPlayerData()
    hunger = p.metadata.hunger or 100
    thirst = p.metadata.thirst or 100
    stress = p.metadata.stress or 0
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    hunger = val.metadata.hunger or hunger
    thirst = val.metadata.thirst or thirst
    stress = val.metadata.stress or stress
end)

-- Decay loop (every minute)
CreateThread(function()
    while true do
        Wait(60000)
        if LocalPlayer.state.isLoggedIn then
            hunger = math.max(0, hunger - 0.15)
            thirst = math.max(0, thirst - 0.22)
            if hunger <= 0 or thirst <= 0 then
                local ped = PlayerPedId()
                SetEntityHealth(ped, GetEntityHealth(ped) - (hunger <= 0 and 5 or 8))
            end
            TriggerServerEvent('rp-needs:server:update', hunger, thirst, stress)
        end
    end
end)

-- Stress when shooting
CreateThread(function()
    while true do
        Wait(0)
        if IsPedShooting(PlayerPedId()) then
            stress = math.min(100, stress + 2)
            Wait(500)
        else
            Wait(500)
        end
    end
end)

exports('GetNeeds', function() return { hunger = hunger, thirst = thirst, stress = stress } end)
