Config = {
    Duty = vector3(441.79, -982.0, 30.69),
    Locker = vector3(452.6, -992.8, 30.69),
    Armory = vector3(482.4, -995.3, 30.69),
    Evidence = vector3(475.8, -996.5, 26.27),
    Garage = vector4(452.0, -1017.5, 28.5, 90.0),
    Heli = vector4(449.5, -981.2, 43.69, 90.0),
    Vehicles = { 'police', 'police2', 'police3' },
    RankVehicles = {
        [0] = {
            { model = 'police', label = 'Patrol Cruiser', speed = 110 },
            { model = 'police2', label = 'Interceptor', speed = 120 },
        },
        [1] = {
            { model = 'police3', label = 'Patrol SUV', speed = 126 },
            { model = 'police4', label = 'Unmarked Cruiser', speed = 132 },
        },
        [2] = {
            { model = 'sheriff', label = 'Sheriff Cruiser', speed = 138 },
            { model = 'sheriff2', label = 'Sheriff SUV', speed = 145 },
        },
        [3] = {
            { model = 'fbi', label = 'FBI Cruiser', speed = 152 },
            { model = 'fbi2', label = 'FBI SUV', speed = 160 },
        },
        [4] = {
            { model = 'policeold1', label = 'Classic Cruiser', speed = 166 },
            { model = 'policeold2', label = 'Classic SUV', speed = 174 },
        },
    },
    HeliModel = 'polmav',
    Outfits = { male = {}, female = {} },
}
