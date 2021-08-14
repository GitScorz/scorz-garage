ESX = nil

TriggerEvent(Config.ESXObject, function(obj) ESX = obj end)

ESX.RegisterServerCallback('scorz_garage:hasMoneyToPayImp', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getMoney() >= Config.ImpoundPay)
end)

RegisterServerEvent("scorz_garage:payImp")
AddEventHandler("scorz_garage:payImp", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    xPlayer.removeMoney(Config.ImpoundPay)
end)

ESX.RegisterServerCallback("scorz_garage:validateVehicle", function(source, cb, vehicleProps)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate
		]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = vehicleProps["plate"]
		}, function(responses)
			if responses[1] then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('scorz_garage:getOwnedVehicles', function(source, cb, garage)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ownedCars = {}
    
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND garage = @garage', {
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@garage'] = garage
	}, function(data)
        for _,v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars,
			{ 
				vehicle = vehicle,
			 	plate = v.plate,
			  	vehModel = v.model
			})
        end
        -- callback
        cb(ownedCars)

    end)
end)

ESX.RegisterServerCallback('scorz_garage:getPlayerVehiclesOut', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local outCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND garage = @garage', {
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@garage'] = 'OUT'
	}, function(data)
        for _,v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
			table.insert(outCars, 
			{
				vehicle = vehicle,
				plate = v.plate,
				vehModel = v.model,
				vehProps = v.vehicle
			})
        end
        -- callback
        cb(outCars)

    end)
end)

function getPlayerVehiclesOut(identifier, cb)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@owner", {
        ['@owner'] = identifier
    })	
	cb(data)
end

RegisterServerEvent('scorz_garage:updateState')
AddEventHandler('scorz_garage:updateState', function(vehicleProps, state, garage)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = vehicleProps.plate

	if garage == nil then
		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = "OUT" , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
	else 
		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
	end
end)