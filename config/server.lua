--[[
    Shared server configuration for all rp-* resources.
    Edit prices, paychecks, and limits here — resources load this via rp-core.
]]

Config = Config or {}

-- General
Config.ServerName = 'Los Santos Roleplay'
Config.StartingCash = 500
Config.StartingBank = 2500
Config.MaxCharacters = 5
Config.PaycheckIntervalMinutes = 60 -- Hourly paychecks
Config.TaxRate = 0.05 -- 5% income tax on paychecks
Config.InsuranceMonthly = 150

-- Starter vehicle (moped) — given on first character spawn
Config.StarterVehicle = {
    model = 'faggio2',
    plate = nil, -- auto-generated
    garage = 'pillboxgarage',
}

-- Blocked clothing for character creator (emergency uniforms)
Config.BlockedUniformComponents = {
    -- componentId = { drawable ranges that are blocked at creation }
    [11] = { { min = 55, max = 58 }, { min = 200, max = 210 } }, -- example torso ranges
}

-- Emergency job names — uniforms only while on duty
Config.EmergencyJobs = { 'police', 'ambulance', 'fire' }

-- Hunger / Thirst / Stress
Config.Needs = {
    HungerDecay = 0.15,      -- per minute
    ThirstDecay = 0.22,
    StressGainShooting = 2.0,
    StressReliefItems = { ['joint'] = 15, ['whiskey'] = 10 },
    StarvationDamage = 5,
    DehydrationDamage = 8,
}

-- Fuel
Config.Fuel = {
    PricePerLiter = 2.85,
    DefaultCapacity = 65.0,
    ConsumptionMultiplier = 1.0,
    GasStations = {
        { coords = vector3(49.42, 2778.79, 58.04), label = 'Route 68 Gas' },
        { coords = vector3(263.89, 2606.46, 44.98), label = 'Harmony Gas' },
        { coords = vector3(1039.95, 2671.13, 39.55), label = 'Sandy Shores Gas' },
        { coords = vector3(1207.26, -1402.05, 35.22), label = 'Mirror Park Gas' },
        { coords = vector3(-70.21, -1761.79, 29.53), label = 'Grove Street Gas' },
        { coords = vector3(-525.98, -1211.98, 18.18), label = 'La Puerta Gas' },
        { coords = vector3(-724.61, -935.16, 19.21), label = 'Little Seoul Gas' },
        { coords = vector3(1181.38, -330.84, 69.31), label = 'East Vinewood Gas' },
    },
}

-- Driving licence
Config.Licences = {
    TheoryTestCost = 250,
    DrivingTestCost = 500,
    FineNoLicence = 1500,
    DrivingSchool = vector3(240.03, -1379.89, 33.74),
}

-- Housing
Config.Housing = {
    MaxOwned = 2,
    RentDueDays = 7,
    PropertyTaxRate = 0.02,
}

-- Criminal
Config.Crime = {
    ATM = {
        RequiredItem = 'lockpick',
        DurationSeconds = 45,
        FailChance = 0.25,
        MinPayout = 800,
        MaxPayout = 3500,
        PoliceAlert = true,
    },
    Bank = {
        RequiredItems = { 'thermite', 'usb_hack' },
        LockpickItem = 'lockpick',
        DurationSeconds = 120,
        MinPayout = 25000,
        MaxPayout = 85000,
        PoliceAlertImmediate = true,
    },
}

-- Dark web items (prices)
Config.DarkWeb = {
    BrowserCost = 5000,
    Items = {
        fake_id = 2500,
        fake_driver_licence = 3500,
        police_tracker = 8000,
        lockpick = 450,
        thermite = 1200,
        usb_hack = 2800,
    },
    MinBounty = 5000,
    MaxBounty = 500000,
}

-- Phone
Config.Phone = {
    DefaultNumberPrefix = '555',
    TakTikMaxVideoLength = 60,
    MarketplaceFee = 0.05,
}

-- Inventory weight (if not using ox_inventory defaults)
Config.Inventory = {
    MaxWeight = 120000, -- grams
    MaxSlots = 50,
}

return Config
