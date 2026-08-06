--[[ rp-character client - validates appearance, blocks EMS/PD/Fire uniforms at creation ]]

local EmergencyJobs = { 'police', 'ambulance', 'fire' }

--- Block emergency uniform drawables during character creation
exports('ValidateAppearance', function(appearance)
    if not appearance then return true end
    -- Block common police/EMS torso drawables (customize per clothing pack)
    local blockedTorso = { 55, 56, 57, 58, 200, 201, 202 }
    if appearance.components then
        for _, comp in pairs(appearance.components) do
            if comp.component_id == 11 then
                for _, b in ipairs(blockedTorso) do
                    if comp.drawable == b then
                        lib.notify({ title = 'Character Creator', description = 'Emergency uniforms are not available during creation.', type = 'error' })
                        return false
                    end
                end
            end
        end
    end
    return true
end)

--- Character creation fields reminder (works with qb-multicharacter + illenium)
RegisterNetEvent('rp-character:client:openCreator', function()
    lib.notify({
        title = 'Create Character',
        description = 'Enter first name, last name, DOB, gender, then customize appearance.',
        type = 'inform',
        duration = 8000,
    })
    TriggerEvent('illenium-appearance:client:openCreator')
    TriggerEvent('qb-multicharacter:client:createCharacter')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local player = QBCore.Functions.GetPlayerData()
    if not player or not player.charinfo or not player.charinfo.firstname or player.charinfo.firstname == '' then
        TriggerEvent('rp-character:client:openCreator')
    end
end)

-- Hook into appearance save
AddEventHandler('illenium-appearance:client:appearanceSaved', function(appearance)
    if not exports['rp-character']:ValidateAppearance(appearance) then
        -- Re-open creator if invalid
        TriggerEvent('illenium-appearance:client:reloadSkin')
    end
end)
