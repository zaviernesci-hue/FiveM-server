--[[ rp-character server - charinfo validation ]]

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-character:server:validateCharinfo', function(charinfo)
    local src = source
    if not charinfo or not charinfo.firstname or not charinfo.lastname then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'First and last name required.', type = 'error' })
        return
    end
    if not charinfo.birthdate then
        TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'Date of birth required.', type = 'error' })
        return
    end
end)
