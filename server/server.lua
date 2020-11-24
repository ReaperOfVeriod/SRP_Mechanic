local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- register mechanic tools and call client script to use them.
ESX.RegisterUsableItem('mechanictools', function(source)
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fixVehicle', source, xPlayer.getInventoryItem('mechanictools').count)
end)

-- toolkit registration for roadside repairs
ESX.RegisterUsableItem('peasanttools', function(source)
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('roadsideFix', source, xPlayer.getInventoryItem('peasanttools').count)
end)

-- command registration for vehicle info
RegisterCommand('vehicleinfo', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('vehicleInfo', source)
end)

-- command registration for flipping car
RegisterCommand('flipcar', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('flipCar', source)
end)



-- command registration for test 
RegisterCommand('tow', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('tow', source)
end)