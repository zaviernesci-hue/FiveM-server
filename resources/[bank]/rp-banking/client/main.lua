--[[ rp-banking client - ATM / bank zones ]]

local banks = {
    vector3(149.46, -1040.53, 29.37),
    vector3(-1212.98, -330.84, 37.79),
    vector3(-2962.58, 482.63, 15.70),
    vector3(314.23, -278.83, 54.17),
}

local function openBankMenu()
    lib.registerContext({
        id = 'rp_bank_menu',
        title = 'Fleeca Bank',
        options = {
            { title = 'View Balance', onSelect = function()
                local p = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
                lib.notify({ title = 'Balance', description = 'Bank: $' .. (p.money.bank or 0), type = 'inform' })
            end},
            { title = 'Deposit', onSelect = function()
                local input = lib.inputDialog('Deposit', {
                    { type = 'number', label = 'Amount' },
                })
                if input then TriggerServerEvent('rp-banking:server:deposit', input[1]) end
            end},
            { title = 'Withdraw', onSelect = function()
                local input = lib.inputDialog('Withdraw', {
                    { type = 'number', label = 'Amount' },
                })
                if input then TriggerServerEvent('rp-banking:server:withdraw', input[1]) end
            end},
            { title = 'Transfer', onSelect = function()
                local input = lib.inputDialog('Transfer', {
                    { type = 'number', label = 'Player Server ID' },
                    { type = 'number', label = 'Amount' },
                    { type = 'input', label = 'Note' },
                })
                if input then TriggerServerEvent('rp-banking:server:transfer', input[1], input[2], input[3]) end
            end},
        },
    })
    lib.showContext('rp_bank_menu')
end

local function nearAnyBank()
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, coords in ipairs(banks) do
        if #(pCoords - coords) < 2.5 then return true end
    end
    return false
end

RegisterNetEvent('rp-banking:client:openMenu', openBankMenu)

CreateThread(function()
    for _, coords in ipairs(banks) do
        exports.ox_target:addSphereZone({
            coords = coords, radius = 1.5,
            options = {
                {
                    name = 'rp_bank',
                    icon = 'fas fa-university',
                    label = 'Access Bank',
                    onSelect = function()
                        lib.registerContext({
                            id = 'rp_bank_menu',
                            title = 'Fleeca Bank',
                            options = {
                                { title = 'View Balance', onSelect = function()
                                    local p = exports['qb-core']:GetCoreObject().Functions.GetPlayerData()
                                    lib.notify({ title = 'Balance', description = 'Bank: $' .. (p.money.bank or 0), type = 'inform' })
                                end},
                                { title = 'Deposit', onSelect = function()
                                    local input = lib.inputDialog('Deposit', {
                                        { type = 'number', label = 'Amount' },
                                    })
                                    if input then TriggerServerEvent('rp-banking:server:deposit', input[1]) end
                                end},
                                { title = 'Withdraw', onSelect = function()
                                    local input = lib.inputDialog('Withdraw', {
                                        { type = 'number', label = 'Amount' },
                                    })
                                    if input then TriggerServerEvent('rp-banking:server:withdraw', input[1]) end
                                end},
                                { title = 'Transfer', onSelect = function()
                                    local input = lib.inputDialog('Transfer', {
                                        { type = 'number', label = 'Player Server ID' },
                                        { type = 'number', label = 'Amount' },
                                        { type = 'input', label = 'Note' },
                                    })
                                    if input then TriggerServerEvent('rp-banking:server:transfer', input[1], input[2], input[3]) end
                                end},
                            },
                        })
                        lib.showContext('rp_bank_menu')
                    end,
                },
            },
        })
    end
end)
