local school = vector3(240.03, -1379.89, 33.74)

CreateThread(function()
    exports.ox_target:addSphereZone({
        coords = school, radius = 2.0,
        options = {
            { name = 'theory', icon = 'fas fa-book', label = 'Theory Test ($250)', onSelect = function()
                TriggerServerEvent('rp-licences:server:buyTest', 'theory')
            end},
            { name = 'driving', icon = 'fas fa-car', label = 'Driving Test ($500)', onSelect = function()
                TriggerServerEvent('rp-licences:server:buyTest', 'driving')
            end},
        },
    })
end)

RegisterNetEvent('rp-licences:client:startTest', function(testType)
    if testType == 'theory' then
        local questions = {
            { q = 'Stop sign means?', a = { 'Stop completely', 'Slow down', 'Speed up' }, correct = 1 },
            { q = 'Speed limit in city?', a = { '35 MPH', '100 MPH', 'No limit' }, correct = 1 },
        }
        local score = 0
        for _, qu in ipairs(questions) do
            local input = lib.inputDialog('Theory Test', {{ type = 'select', label = qu.q, options = qu.a }})
            if input and input[1] == qu.a[qu.correct] then score = score + 1 end
        end
        if score >= #questions then
            lib.notify({ title = 'DMV', description = 'Theory passed! Take driving test next.', type = 'success' })
        else
            lib.notify({ title = 'DMV', description = 'Failed theory test.', type = 'error' })
        end
    else
        lib.notify({ title = 'DMV', description = 'Follow the checkpoint route...', type = 'inform' })
        Wait(30000)
        TriggerServerEvent('rp-licences:server:passTest', 'driving')
    end
end)

-- Block illegal car driving without licence
CreateThread(function()
    while true do
        Wait(3000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
            local model = GetEntityModel(GetVehiclePedIsIn(ped, false))
            if model ~= joaat('faggio2') and model ~= joaat('faggio') then
                lib.callback('rp-licences:hasLicence', false, function(has)
                    if not has then
                        lib.notify({ title = 'Warning', description = 'No driver licence — moped only legal vehicle', type = 'error' })
                    end
                end, 'driver')
            end
        end
    end
end)
