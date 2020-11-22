local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- register mechanic tools and call client script to use them.
ESX.RegisterUsableItem('mechanictools', function(source)
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('fixVehicle', source, xPlayer.getInventoryItem('mechanictools').count)
end)

RegisterCommand('mechtest', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('mechtest1', source)
end)

RegisterCommand('mechtestfix', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('mechtest2', source)
end)

RegisterCommand('mechtestflip', function(source,args,raw)
    local source = tonumber(source)
    TriggerClientEvent('mechtest3', source)
end)