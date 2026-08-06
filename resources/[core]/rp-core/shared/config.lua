--[[ rp-core shared - loads external config from the project root config/ folder ]] 

local function mergeTables(target, source)
    if type(target) ~= 'table' or type(source) ~= 'table' then
        return target
    end

    for key, value in pairs(source) do
        if type(value) == 'table' and type(target[key]) == 'table' then
            mergeTables(target[key], value)
        else
            target[key] = value
        end
    end

    return target
end

local function loadExternalConfig(filename)
    local configRoot = GetConvar('rp:configPath', 'config')
    local candidates = {
        configRoot .. '/' .. filename,
        '../../../' .. configRoot .. '/' .. filename,
        '../../' .. configRoot .. '/' .. filename,
    }

    for _, candidate in ipairs(candidates) do
        local raw = LoadResourceFile(GetCurrentResourceName(), candidate)
        if not raw then
            raw = LoadResourceFile('rp-core', candidate)
        end

        if raw then
            local fn, err = load(raw, '@config/' .. filename)
            if fn then
                local loaded = fn()
                if type(loaded) == 'table' then
                    return loaded
                end
            else
                print(('[rp-core] Config load error for %s: %s'):format(filename, tostring(err)))
            end
        end
    end

    return nil
end

-- Inline fallback configs if external path is unavailable
Config = Config or {
    ServerName = 'Los Santos Roleplay',
    StartingCash = 500,
    StartingBank = 2500,
    PaycheckIntervalMinutes = 60,
    TaxRate = 0.05,
    EmergencyJobs = { 'police', 'ambulance', 'fire' },
    StarterVehicle = { model = 'faggio2', garage = 'pillboxgarage' },
}

JobsConfig = JobsConfig or { List = {} }
VehiclesConfig = VehiclesConfig or { Catalog = {}, Dealerships = {} }

local loadedConfig = loadExternalConfig('server.lua')
if type(loadedConfig) == 'table' then
    mergeTables(Config, loadedConfig)
end

local loadedJobs = loadExternalConfig('jobs.lua')
if type(loadedJobs) == 'table' then
    mergeTables(JobsConfig, loadedJobs)
    if type(loadedJobs.List) == 'table' then
        JobsConfig.List = mergeTables(JobsConfig.List or {}, loadedJobs.List)
    end
end

local loadedVehicles = loadExternalConfig('vehicles.lua')
if type(loadedVehicles) == 'table' then
    mergeTables(VehiclesConfig, loadedVehicles)
    if type(loadedVehicles.Catalog) == 'table' then
        VehiclesConfig.Catalog = loadedVehicles.Catalog
    end
    if type(loadedVehicles.Dealerships) == 'table' then
        VehiclesConfig.Dealerships = loadedVehicles.Dealerships
    end
end
