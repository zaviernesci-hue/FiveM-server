local atms = {
    vector3(147.04, -1035.73, 29.34),
    vector3(-386.733, 6045.953, 31.501),
    vector3(-284.037, 6224.385, 31.187),
    vector3(-135.165, 6365.738, 31.101),
}

CreateThread(function()
    for _, c in ipairs(atms) do
        exports.ox_target:addSphereZone({
            coords = c, radius = 1.0,
            options = {{
                name = 'rob_atm', icon = 'fas fa-mask', label = 'Rob ATM (Lockpick)',
                onSelect = function()
                    if lib.progressBar({ duration = 45000, label = 'Breaking into ATM...', canCancel = true, disable = { move = true } }) then
                        TriggerServerEvent('rp-crime:server:atmRobbery', c)
                    end
                end,
            }},
        })
    end
end)

local bankCoords = vector3(253.92, 228.47, 101.68)
exports.ox_target:addSphereZone({
    coords = bankCoords, radius = 2.0,
    options = {{
        name = 'rob_bank', icon = 'fas fa-vault', label = 'Rob Vault (Thermite + USB)',
        onSelect = function()
            if lib.progressBar({ duration = 120000, label = 'Hacking vault...', canCancel = true, disable = { move = true } }) then
                TriggerServerEvent('rp-crime:server:bankRobbery', bankCoords)
            end
        end,
    }},
})
