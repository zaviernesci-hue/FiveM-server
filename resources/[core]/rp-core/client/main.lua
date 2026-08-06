--[[ rp-core client ]]

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('rp-core:server:giveStarterVehicle')
end)

exports('GetConfig', function()
    return exports['rp-core']:GetConfig()
end)
