-- request vehicle info
RegisterNetEvent('vehicleInfo')
AddEventHandler('vehicleInfo', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        local vBody = GetVehicleBodyHealth(vehicle)
        local vEngine = GetVehicleEngineHealth(vehicle)
        -- local vWheel =
        local vTank = GetVehiclePetrolTankHealth(vehicle)
        print('body :' .. vBody)
        print('engine: ' .. vEngine)
        print('tank: ' .. vTank)
    end
end)


-- flip car
RegisterNetEvent('flipCar')
AddEventHandler('flipCar', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

        local coords = GetEntityCoords(vehicle)
        local xPos = coords[1]
        local yPos = coords[2]
        local zPos = coords[3]
        local xAxis = false
        local yAxis = false
        local zAxis = false

        SetEntityCoords(vehicle, xPos, yPos, zPos, xAxis, yAxis, zAxis, false)
    end
end)



--[[
SetVehicleTyreFixed(vehicle, integer)

tyreIndex = 0 to 4 on normal vehicles  
'0 = wheel_lf / bike, plane or jet front  
'1 = wheel_rf  
'2 = wheel_lm / in 6 wheels trailer, plane or jet is first one on left  
'3 = wheel_rm / in 6 wheels trailer, plane or jet is first one on right  
'4 = wheel_lr / bike rear / in 6 wheels trailer, plane or jet is last one on left  
'5 = wheel_rr / in 6 wheels trailer, plane or jet is last one on right  
'45 = 6 wheels trailer mid wheel left  
'47 = 6 wheels trailer mid wheel right  
]]

-- partial fix event
RegisterNetEvent('roadsideFix')
AddEventHandler('roadsideFix', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

        if GetVehicleEngineHealth(vehicle) < 350 then
            SetVehicleEngineHealth(vehicle, 350.0)
        end

        if GetVehiclePetrolTankHealth(vehicle) < 700 then
            SetVehiclePetrolTankHealth(vehicle, 700.0)
        end
        
        SetVehicleTyreFixed(vehicle, 0)
        SetVehicleTyreFixed(vehicle, 1)
        SetVehicleTyreFixed(vehicle, 2)
        SetVehicleTyreFixed(vehicle, 3)
        SetVehicleTyreFixed(vehicle, 4)
        SetVehicleTyreFixed(vehicle, 5)
        SetVehicleTyreFixed(vehicle, 45)
        SetVehicleTyreFixed(vehicle, 47)
    end
end)

-- full fix event
RegisterNetEvent('fixVehicle')
AddEventHandler('fixVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end

        if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
            Citizen.CreateThread(function()
                Citizen.Wait(5000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                --ESX.ShowNotification(_U('veh_repaired'))
            end)
        end
    end
end)

