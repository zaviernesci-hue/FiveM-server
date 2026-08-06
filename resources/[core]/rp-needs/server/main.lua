--[[ rp-needs server - persist metadata ]]

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rp-needs:server:update', function(hunger, thirst, stress)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    hunger = math.max(0, math.min(100, hunger))
    thirst = math.max(0, math.min(100, thirst))
    stress = math.max(0, math.min(100, stress))
    Player.Functions.SetMetaData('hunger', hunger)
    Player.Functions.SetMetaData('thirst', thirst)
    Player.Functions.SetMetaData('stress', stress)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local meta = Player.PlayerData.metadata
    if not meta.hunger then Player.Functions.SetMetaData('hunger', 100) end
    if not meta.thirst then Player.Functions.SetMetaData('thirst', 100) end
    if not meta.stress then Player.Functions.SetMetaData('stress', 0) end
end)
