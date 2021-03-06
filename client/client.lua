mechShops = {}
mechShops[0] = {vector3(1117.0, -765.0, 0.0), vector3(1117.0, -802.0, 0.0), vector3(1163.0, -802.0, 0.0), vector3(1163.0, -765.0, 0.0)} -- elgin ave
mechShops[1] = {vector3(555.0, -163.0, 0.0), vector3(556.0, -202.0, 0.0), vector3(530.0, -249.0, 0.0), vector3(517.0, -164.0, 0.0)} -- mirror park
mechShops[2] = {vector3(490.0, -1301.0, 0.0), vector3(441.0, -1317.0, 0.0), vector3(481.0, -1343.0, 0.0), vector3(519.0, -1344.0, 0.0)} -- hayes auto
mechShops[3] = {vector3(-11.0, -1415.0, 0.0), vector3(-11.0, -1378.0, 0.0), vector3(-33.0, -1378.0, 0.0), vector3(-33.0, -1415.0, 0.0)} -- stoner shop


--calculate area of perimiter using shoelace algorythm
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
            isInMechanicShop1 = false
            for k, v in pairs(mechShops) do

                local aVector = mechShops[k][1]
                local bVector = mechShops[k][2]
                local cVector = mechShops[k][3]
                local dVector = mechShops[k][4]

                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)

                -- all vectors defined down to X and Y axis
                local pVectorX = coords.x
                local pVectorY = coords.y
                local aVectorX = aVector.x
                local aVectorY = aVector.y
                local bVectorX = bVector.x
                local bVectorY = bVector.y
                local cVectorX = cVector.x
                local cVectorY = cVector.y
                local dVectorX = dVector.x
                local dVectorY = dVector.y
            
                mechShopArea = {{aVectorX,aVectorY}, {bVectorX,bVectorY}, {cVectorX,cVectorY}, {dVectorX,dVectorY}}

                -- calculation to calculate a triangulation of all vectors to see if player is in a set perimiter
                local table1 = {{aVectorX, aVectorY}, {pVectorX, pVectorY}, {dVectorX,dVectorY}}
                local delta1 = shoeArea(table1)
                local table2 = {{dVectorX,dVectorY}, {pVectorX,pVectorY}, {cVectorX, cVectorY}}
                local delta2 = shoeArea(table2)
                local table3 = {{cVectorX, cVectorY}, {pVectorX, pVectorY}, {bVectorX, bVectorY}}
                local delta3 = shoeArea(table3)
                local table4 = {{pVectorX,pVectorY}, {bVectorX,bVectorY}, {aVectorX,aVectorY}}
                local delta4 = shoeArea(table4)
                deltaSum = delta1 + delta2 + delta3 + delta4

                if deltaSum == shoeArea(mechShopArea) then --when the for loop hits a mechanic perimiter the player is in set the variable to true
                    isInMechanicShop1 = true
                end 
            end

            if isInMechanicShop1 == true then
                exports['mythic_notify']:SendAlert('inform', 'You are in a mechanic area', 6000)
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
                exports['mythic_notify']:SendAlert('error', 'you arent in a mechanic shop dumbfuck', 6000)
            end
        end
    end)
end)

local currentlyTowedVehicle = nil

RegisterNetEvent('tow')
AddEventHandler('tow', function()
    

    local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						currentlyTowedVehicle = targetVehicle
						exports['mythic_notify']:SendAlert('inform', 'Car has been put on the tow truck!', 6000)
					else
						exports['mythic_notify']:SendAlert('error', 'you fucking numbwit you cant tow your own vehicle...', 6000)
					end
				end
			else
				exports['mythic_notify']:SendAlert('error', 'ay dumbfuck where is the vehicle to tow..', 6000)
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			currentlyTowedVehicle = nil
			exports['mythic_notify']:SendAlert('inform', 'Car has been taken off the tow truck!', 6000)
		end
	end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
