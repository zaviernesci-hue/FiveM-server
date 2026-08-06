--[[
    Dealership catalog — prices, categories, finance options.
]]

Vehicles = Vehicles or {}

Vehicles.Dealerships = {
    ['pdm'] = {
        label = 'Premium Deluxe Motorsport',
        coords = vector3(-56.79, -1098.9, 26.42),
        spawn = vector4(-12.5, -1082.3, 26.67, 160.0),
        testDrive = vector4(-49.5, -1111.0, 26.67, 70.0),
        categories = { 'compacts', 'sedans', 'sports', 'suvs' },
    },
    ['luxury'] = {
        label = 'Luxury Autos',
        coords = vector3(-795.15, -220.86, 37.08),
        spawn = vector4(-768.5, -243.2, 37.12, 200.0),
        testDrive = vector4(-760.0, -230.0, 37.12, 120.0),
        categories = { 'sports', 'super', 'muscle' },
    },
}

Vehicles.Catalog = {
    -- Compacts / starter tier
    { model = 'blista', label = 'Blista', price = 8500, category = 'compacts', finance = true },
    { model = 'dilettante', label = 'Dilettante', price = 6500, category = 'compacts', finance = true },
    { model = 'issi2', label = 'Issi', price = 7200, category = 'compacts', finance = true },
    -- Sedans
    { model = 'asea', label = 'Asea', price = 12000, category = 'sedans', finance = true },
    { model = 'fugitive', label = 'Fugitive', price = 18500, category = 'sedans', finance = true },
    { model = 'stanier', label = 'Stanier', price = 14000, category = 'sedans', finance = true },
    -- Sports
    { model = 'elegy2', label = 'Elegy RH8', price = 95000, category = 'sports', finance = true },
    { model = 'jester', label = 'Jester', price = 125000, category = 'sports', finance = true },
    -- SUVs
    { model = 'baller', label = 'Baller', price = 45000, category = 'suvs', finance = true },
    { model = 'granger', label = 'Granger', price = 38000, category = 'suvs', finance = true },
    -- Super
    { model = 'adder', label = 'Adder', price = 850000, category = 'super', finance = true },
    { model = 'zentorno', label = 'Zentorno', price = 725000, category = 'super', finance = true },
    -- Job vehicles (not sold at PDM — reference only)
    { model = 'police', label = 'Police Cruiser', price = 0, category = 'emergency', job = 'police' },
    { model = 'ambulance', label = 'Ambulance', price = 0, category = 'emergency', job = 'ambulance' },
    { model = 'firetruk', label = 'Fire Truck', price = 0, category = 'emergency', job = 'fire' },
}

Vehicles.Finance = {
    MinDownPayment = 0.15,
    MaxMonths = 24,
    InterestRate = 0.08,
}

return Vehicles
