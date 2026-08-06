--[[
    Shared utility functions used across client and server.
    Loaded by rp-core.
]]

RP = RP or {}
RP.Utils = {}

--- Round number to decimals
function RP.Utils.Round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

--- Format money with commas
function RP.Utils.FormatMoney(amount)
    local formatted = tostring(math.floor(amount))
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return '$' .. formatted
end

--- Generate random plate
function RP.Utils.GeneratePlate()
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local plate = ''
    for i = 1, 8 do
        local idx = math.random(1, #charset)
        plate = plate .. charset:sub(idx, idx)
    end
    return plate
end

--- Distance check helper (client-side vector3)
function RP.Utils.GetDistance(coords1, coords2)
    return #(coords1 - coords2)
end

--- Validate citizenid format
function RP.Utils.IsValidCitizenId(id)
    return type(id) == 'string' and #id >= 6
end

--- Deep copy table
function RP.Utils.DeepCopy(orig)
    local copy
    if type(orig) == 'table' then
        copy = {}
        for k, v in next, orig, nil do
            copy[RP.Utils.DeepCopy(k)] = RP.Utils.DeepCopy(v)
        end
    else
        copy = orig
    end
    return copy
end

--- Check if job is emergency service
function RP.Utils.IsEmergencyJob(jobName, emergencyJobs)
    for _, j in ipairs(emergencyJobs or {}) do
        if j == jobName then return true end
    end
    return false
end

return RP
