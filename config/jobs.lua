--[[
    Job definitions: hourly pay (deposited to bank), grades, vehicles, locations.
    Pay is per paycheck interval (Config.PaycheckIntervalMinutes in server.lua).
]]

Jobs = Jobs or {}

Jobs.List = {
    police = {
        label = 'Los Santos Police Department',
        defaultDuty = false,
        offDutyPay = false,
        hourlyPay = 1400,
        progression = {
            rankUps = {
                [0] = { name = 'Cadet', payment = 950, unlocks = { 'patrol' } },
                [1] = { name = 'Officer', payment = 1100, unlocks = { 'traffic', 'backup' } },
                [2] = { name = 'Sergeant', payment = 1300, unlocks = { 'field_supervision' } },
                [3] = { name = 'Lieutenant', payment = 1500, unlocks = { 'command' } },
                [4] = { name = 'Chief', payment = 1800, unlocks = { 'command', 'special_ops' } },
            },
            bonus = { arrest = 250, report = 175, trafficStop = 125 },
        },
        grades = {
            [0] = { name = 'Cadet', payment = 1400, unlocks = { 'patrol' } },
            [1] = { name = 'Officer', payment = 1700, unlocks = { 'traffic', 'backup' } },
            [2] = { name = 'Sergeant', payment = 2100, unlocks = { 'field_supervision' } },
            [3] = { name = 'Lieutenant', payment = 2500, unlocks = { 'command' } },
            [4] = { name = 'Chief', payment = 3200, unlocks = { 'command', 'special_ops' } },
        },
        stations = {
            duty = vector3(441.79, -982.0, 30.69),
            locker = vector3(452.6, -992.8, 30.69),
            armory = vector3(482.4, -995.3, 30.69),
            evidence = vector3(475.8, -996.5, 26.27),
            garage = vector4(452.0, -1017.5, 28.5, 90.0),
            heli = vector4(449.5, -981.2, 43.69, 90.0),
        },
    },
    ambulance = {
        label = 'Pillbox Medical Center',
        defaultDuty = false,
        offDutyPay = false,
        hourlyPay = 1300,
        progression = {
            bonus = { revive = 220, transport = 140, treatment = 95 },
        },
        grades = {
            [0] = { name = 'Trainee', payment = 1300, unlocks = { 'basic_treatment' } },
            [1] = { name = 'Paramedic', payment = 1550, unlocks = { 'advanced_treatment' } },
            [2] = { name = 'Doctor', payment = 1900, unlocks = { 'critical_care' } },
            [3] = { name = 'Surgeon', payment = 2300, unlocks = { 'surgery' } },
        },
        stations = {
            duty = vector3(311.2, -599.4, 43.29),
            locker = vector3(298.5, -598.2, 43.29),
            garage = vector4(294.5, -574.8, 43.18, 70.0),
        },
    },
    fire = {
        label = 'Los Santos Fire Department',
        defaultDuty = false,
        offDutyPay = false,
        hourlyPay = 1450,
        progression = {
            bonus = { rescue = 240, extinguish = 135, structure = 180 },
        },
        grades = {
            [0] = { name = 'Probationary', payment = 1450, unlocks = { 'rescue' } },
            [1] = { name = 'Firefighter', payment = 1750, unlocks = { 'wildfire' } },
            [2] = { name = 'Engineer', payment = 2100, unlocks = { 'hazmat' } },
            [3] = { name = 'Captain', payment = 2600, unlocks = { 'command' } },
        },
        stations = {
            duty = vector3(215.5, -1642.8, 29.8),
            locker = vector3(210.2, -1651.5, 29.8),
            garage = vector4(209.0, -1638.5, 29.29, 320.0),
        },
    },
    taxi = {
        label = 'Downtown Cab Co.',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 500,
        progression = {
            bonus = { fare = 18, vip = 120, longTrip = 65 },
        },
        grades = { [0] = { name = 'Driver', payment = 500, unlocks = { 'standard_fares' } }, [1] = { name = 'Veteran', payment = 650, unlocks = { 'priority_pickups' } }, [2] = { name = 'Elite', payment = 850, unlocks = { 'vip_service' } } },
        stations = { duty = vector3(894.5, -179.2, 74.0) },
        farePerKm = 12,
        baseFare = 25,
    },
    mechanic = {
        label = 'LS Customs',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 900,
        progression = {
            bonus = { repair = 140, tune = 180, custom = 260 },
        },
        grades = {
            [0] = { name = 'Apprentice', payment = 900, unlocks = { 'basic_repairs' } },
            [1] = { name = 'Mechanic', payment = 1150, unlocks = { 'performance_tunes' } },
            [2] = { name = 'Master', payment = 1500, unlocks = { 'custom_builds' } },
        },
        stations = {
            duty = vector3(-347.3, -133.0, 39.0),
            repair = vector3(-339.5, -136.8, 39.0),
        },
        repairCost = 350,
        paintCost = 500,
        engineUpgradeCost = 2500,
    },
    tow = {
        label = 'Hayes Auto Tow',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 800,
        progression = {
            bonus = { tow = 160, impound = 220, recovery = 300 },
        },
        grades = { [0] = { name = 'Operator', payment = 800, unlocks = { 'towing' } }, [1] = { name = 'Supervisor', payment = 1050, unlocks = { 'impounds' } }, [2] = { name = 'Lead', payment = 1400, unlocks = { 'recovery_contracts' } } },
        impoundPay = 200,
        contractPay = { min = 150, max = 450 },
    },
    trucker = {
        label = 'Freight Logistics',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 850,
        progression = {
            bonus = { delivery = 180, longHaul = 320, hazard = 260 },
        },
        grades = { [0] = { name = 'Driver', payment = 850, unlocks = { 'local_routes' } }, [1] = { name = 'Hauler', payment = 1100, unlocks = { 'long_haul' } }, [2] = { name = 'Captain', payment = 1450, unlocks = { 'priority_contracts' } } },
        deliveryPay = { min = 800, max = 4500 },
        damagePenalty = 0.15,
    },
    delivery = {
        label = 'GoPostal / Burger Shot Delivery',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 450,
        progression = {
            bonus = { package = 95, express = 135, tip = 80 },
        },
        grades = { [0] = { name = 'Courier', payment = 450, unlocks = { 'basic_delivery' } }, [1] = { name = 'Route Lead', payment = 575, unlocks = { 'express_routes' } }, [2] = { name = 'Dispatcher', payment = 720, unlocks = { 'priority_jobs' } } },
        timeBonusMultiplier = 1.25,
        npcPay = { min = 45, max = 120 },
    },
    bus = {
        label = 'LS Transit Authority',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 470,
        progression = {
            bonus = { route = 90, peak = 140, charter = 170 },
        },
        grades = { [0] = { name = 'Driver', payment = 470, unlocks = { 'routes' } }, [1] = { name = 'Senior Driver', payment = 590, unlocks = { 'peak_hours' } }, [2] = { name = 'Operator', payment = 760, unlocks = { 'charter_service' } } },
        routeBonus = 75,
        peakHourBonus = 1.15,
    },
    construction = {
        label = 'BuildCo Construction',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 540,
        progression = {
            bonus = { task = 130, crew = 170, heavy = 260 },
        },
        grades = { [0] = { name = 'Laborer', payment = 540, unlocks = { 'basic_tasks' } }, [1] = { name = 'Crewman', payment = 670, unlocks = { 'crew_leads' } }, [2] = { name = 'Foreman', payment = 860, unlocks = { 'heavy_contracts' } } },
        taskPay = { min = 100, max = 350 },
    },
    electrician = {
        label = 'PowerGrid Services',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 600,
        progression = {
            bonus = { repair = 150, emergency = 230, install = 190 },
        },
        grades = { [0] = { name = 'Technician', payment = 600, unlocks = { 'repairs' } }, [1] = { name = 'Senior Tech', payment = 750, unlocks = { 'emergency_calls' } }, [2] = { name = 'Lead Electrician', payment = 930, unlocks = { 'install_projects' } } },
        contractPay = { min = 200, max = 600 },
    },
    garbage = {
        label = 'Sanitation Department',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 500,
        progression = {
            bonus = { route = 95, landfill = 120, hazardous = 180 },
        },
        grades = { [0] = { name = 'Collector', payment = 500, unlocks = { 'routes' } }, [1] = { name = 'Route Lead', payment = 620, unlocks = { 'landfill_runs' } }, [2] = { name = 'Fleet Lead', payment = 790, unlocks = { 'hazmat' } } },
        routePay = 85,
    },
    farmer = {
        label = 'Grapeseed Farms',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 420,
        progression = {
            bonus = { harvest = 75, livestock = 110, premium = 160 },
        },
        grades = { [0] = { name = 'Farmhand', payment = 420, unlocks = { 'harvest' } }, [1] = { name = 'Grower', payment = 540, unlocks = { 'livestock' } }, [2] = { name = 'Manager', payment = 700, unlocks = { 'premium_crops' } } },
        cropSellPrices = { wheat = 12, corn = 10, tomato = 15, grape = 18 },
    },
    unemployed = {
        label = 'Civilian',
        defaultDuty = true,
        offDutyPay = false,
        hourlyPay = 0,
        grades = { [0] = { name = 'Freelancer', payment = 0 } },
    },
}

return Jobs
