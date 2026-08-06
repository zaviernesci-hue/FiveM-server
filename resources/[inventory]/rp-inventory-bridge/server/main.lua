--[[ Register stashes for housing, police evidence, vehicle trunks ]]

CreateThread(function()
    Wait(1000)
    -- House stashes
    for _, id in ipairs({ 'house_apartment_1', 'house_house_mirror_park' }) do
        exports.ox_inventory:RegisterStash(id, 'Property Storage', 50, 100000, false)
    end
    exports.ox_inventory:RegisterStash('police_evidence', 'Evidence Locker', 100, 200000, false)
end)
