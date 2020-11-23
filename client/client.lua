-- request vehicle info
RegisterNetEvent('vehicleInfo')
AddEventHandler('vehicleInfo', function()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "VehicleInfo",
        duration = Config.VehicleInfoDuration,
        label = "Vehicle inspection...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistdockssetup1clipboard@idle_a",
            anim = "idle_a",
        },
        prop = {
            model = "prop_notepad_01",
            coords = { x = -0.1, y = 0.01, z = -0.05 },
            rotation = { x = 95.0, y = 0.0, z = 0.0 }
        }
    }, function(status)
        if not status then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
                local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
                local vBody = GetVehicleBodyHealth(vehicle)
                local vEngine = GetVehicleEngineHealth(vehicle)
                local vTank = GetVehiclePetrolTankHealth(vehicle)
                exports['mythic_notify']:SendAlert('success', string.format("Body: %s",vBody))
                exports['mythic_notify']:SendAlert('success', string.format("Engine: %s",vEngine))
                exports['mythic_notify']:SendAlert('success', string.format("Tank %s",vTank))
            end
        end
    end)
end)


-- flip car
RegisterNetEvent('flipCar')
AddEventHandler('flipCar', function()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "flipCar",
        duration = Config.FlipCarDuration,
        label = "Flipping vehicle",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@", -- needs new animation set
            anim = "weed_spraybottle_stand_kneeling_01_inspector",
        },
    }, function(status)
        if not status then
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
        end
    end)
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
    TriggerEvent("mythic_progbar:client:progress", {
        name = "Roadsidefix",
        duration = Config.RoadsideFixDuration,
        label = "Roadside vehicle repair",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
        }
    }, function(status)
        if not status then
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
        end
    end)
end)

-- full fix event
RegisterNetEvent('fixVehicle')
AddEventHandler('fixVehicle', function()
    TriggerEvent("mythic_progbar:client:progress", {
        name = "Fullfix",
        duration = Config.FixVehicleDuration,
        label = "Fixing vehicle",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
        }
    }, function(status)
        if not status then
            -- area of this perimeter should be 2152
            local aVectorX = 555.0
            local aVectorY = -163.0
            local bVectorX = 517.0
            local bVectorY = -164.0
            local cVectorX = 530.0
            local cVectorY = -249.0
            local dVectorX = 556.0
            local dVectorY = -202.0

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            local pVectorX = coords.x
            local pVectorY = coords.y
            
            --calculate area of perimiter
            function shoeArea(ps)
                local function ssum(acc, p1, p2, ...)
                if not p2 or not p1 then
                    return math.abs(0.5 * acc)
                else
                    return ssum(acc + p1[1]*p2[2]-p1[2]*p2[1], p2, ...)
                end
                end
                return ssum(0, ps[#ps], table.unpack(ps))
            end
            
            local mechShopArea = {{555.0,-163.0}, {517.0,-164.0}, {530.0,-249.0}, {556.0,-202.0}} --table

            local table1 = {{aVectorX, aVectorY}, {pVectorX, pVectorY}, {dVectorX,dVectorY}}
            local delta1 = shoeArea(table1)
            local table2 = {{dVectorX,dVectorY}, {pVectorX,pVectorY}, {cVectorX, cVectorY}}
            local delta2 = shoeArea(table2)
            local table3 = {{cVectorX, cVectorY}, {pVectorX, pVectorY}, {bVectorX, bVectorY}}
            local delta3 = shoeArea(table3)
            local table4 = {{pVectorX,pVectorY}, {bVectorX,bVectorY}, {aVectorX,aVectorY}}
            local delta4 = shoeArea(table4)
            local deltaSum = delta1 + delta2 + delta3 + delta4

            if deltaSum == shoeArea(mechShopArea) then
                print('you are in the mech area')

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
                        Citizen.CreateThread(function()
                            SetVehicleFixed(vehicle)
                            SetVehicleDeformationFixed(vehicle)
                            SetVehicleUndriveable(vehicle, false)
                            ClearPedTasksImmediately(playerPed)
                            exports['mythic_notify']:SendAlert('inform', 'Car has been fixed', 6000)
                        end)
                    end
                end
            
            else
                print('you are not in the mech area')
                exports['mythic_notify']:SendAlert('error', 'You are not in a mechanic area.', 6000)
            end 
        end
    end)
end)



RegisterNetEvent('mechtest')
AddEventHandler('mechtest', function()

    -- area of this perimeter should be 2152
    local aVectorX = 555.0
    local aVectorY = -163.0
    local bVectorX = 517.0
    local bVectorY = -164.0
    local cVectorX = 530.0
    local cVectorY = -249.0
    local dVectorX = 556.0
    local dVectorY = -202.0

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local pVectorX = coords.x
    local pVectorY = coords.y
    
    --calculate area of perimiter
    function shoeArea(ps)
        local function ssum(acc, p1, p2, ...)
          if not p2 or not p1 then
            return math.abs(0.5 * acc)
          else
            return ssum(acc + p1[1]*p2[2]-p1[2]*p2[1], p2, ...)
          end
        end
        return ssum(0, ps[#ps], table.unpack(ps))
    end
       
    local mechShopArea = {{555.0,-163.0}, {517.0,-164.0}, {530.0,-249.0}, {556.0,-202.0}} --table

    local table1 = {{aVectorX, aVectorY}, {pVectorX, pVectorY}, {dVectorX,dVectorY}}
    local delta1 = shoeArea(table1)
    local table2 = {{dVectorX,dVectorY}, {pVectorX,pVectorY}, {cVectorX, cVectorY}}
    local delta2 = shoeArea(table2)
    local table3 = {{cVectorX, cVectorY}, {pVectorX, pVectorY}, {bVectorX, bVectorY}}
    local delta3 = shoeArea(table3)
    local table4 = {{pVectorX,pVectorY}, {bVectorX,bVectorY}, {aVectorX,aVectorY}}
    local delta4 = shoeArea(table4)
    local deltaSum = delta1 + delta2 + delta3 + delta4

    if deltaSum == shoeArea(mechShopArea) then
        print('you are in the mech area')

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
                Citizen.CreateThread(function()
                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    ClearPedTasksImmediately(playerPed)
                    exports['mythic_notify']:SendAlert('inform', 'Car has been fixed', 6000)
                end)
            end
        end
    
    else
        print('you are not in the mech area')
        exports['mythic_notify']:SendAlert('error', 'You are not in a mechanic area.', 6000)
    end 
      
end)

