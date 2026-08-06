local houseLocations = {
    { id = 'apartment_1', coords = vector3(265.89, -1003.2, 29.29), label = 'South LS Apt' },
    { id = 'apartment_2', coords = vector3(309.7, -594.8, 43.3), label = 'Downtown Loft' },
    { id = 'house_mirror_park', coords = vector3(1300.2, -574.5, 71.73), label = 'Mirror Park House' },
    { id = 'house_vinewood', coords = vector3(340.2, 437.9, 149.4), label = 'Vinewood Mansion' },
    { id = 'house_sandy', coords = vector3(1966.0, 3818.4, 32.3), label = 'Sandy Shores House' },
    { id = 'house_lossoques', coords = vector3(-1817.4, 799.0, 138.5), label = 'Los Santos House' },
}

local function openHouseMenu(p)
    lib.registerContext({
        id = 'house_menu',
        title = p.label,
        options = {
            { title = 'Purchase', onSelect = function() TriggerServerEvent('rp-housing:server:buy', p.id) end },
            { title = 'Stash', onSelect = function() exports.ox_inventory:openInventory('stash', 'house_'..p.id) end },
            { title = 'Give Key', onSelect = function()
                local i = lib.inputDialog('Give Key', {{ type='number', label='Player ID' }})
                if i then TriggerServerEvent('rp-housing:server:giveKey', p.id, i[1]) end
            end},
        },
    })
    lib.showContext('house_menu')
end

local function nearHouse()
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, p in ipairs(houseLocations) do
        if #(pCoords - p.coords) < 3.0 then
            return p
        end
    end
    return nil
end

RegisterCommand('housemenu', function()
    local p = nearHouse()
    if p then
        openHouseMenu(p)
    else
        lib.notify({ title = 'Housing', description = 'You must be near a home to open this menu.', type = 'error' })
    end
end, false)
RegisterKeyMapping('housemenu', 'Open Housing Menu', 'keyboard', 'H')

CreateThread(function()
    for _, p in ipairs(houseLocations) do
        exports.ox_target:addSphereZone({
            coords = p.coords, radius = 2.0,
            options = {
                { name = 'buy_'..p.id, icon = 'fas fa-home', label = 'Purchase / Enter',
                  onSelect = function() openHouseMenu(p) end,
                },
            },
        })
    end
end)
