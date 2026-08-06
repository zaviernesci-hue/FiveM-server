--[[ Dispatch incident types and job routing ]]

Incidents = {
    Types = {
        ['911'] = { label = '911 Call', jobs = { 'police', 'ambulance' }, blip = 480, color = 1 },
        ['atm_robbery'] = { label = 'ATM Robbery', jobs = { 'police' }, blip = 500, color = 1 },
        ['bank_robbery'] = { label = 'Bank Robbery', jobs = { 'police' }, blip = 500, color = 1 },
        ['panic'] = { label = 'Panic Button', jobs = { 'police', 'ambulance' }, blip = 161, color = 1 },
        ['officer_down'] = { label = 'Officer Down', jobs = { 'police', 'ambulance', 'fire' }, blip = 303, color = 1 },
        ['shots_fired'] = { label = 'Shots Fired', jobs = { 'police' }, blip = 110, color = 1 },
        ['vehicle_theft'] = { label = 'Vehicle Theft', jobs = { 'police' }, blip = 225, color = 1 },
        ['medical'] = { label = 'Medical Emergency', jobs = { 'ambulance' }, blip = 153, color = 2 },
        ['house_fire'] = { label = 'House Fire', jobs = { 'fire', 'ambulance' }, blip = 436, color = 1 },
        ['vehicle_fire'] = { label = 'Vehicle Fire', jobs = { 'fire' }, blip = 436, color = 1 },
        ['taxi_request'] = { label = 'Taxi Request', jobs = { 'taxi' }, blip = 198, color = 5 },
    },
}
