ESX 		= nil

PlayerData 	= {}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESXObject, function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
    
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
    end
    
	PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	SetTextScale(0.32, 0.32)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 500
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end
  
function notify(msg)
	ESX.ShowNotification(msg)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.ImpoundLocation[1], Config.ImpoundLocation[2], Config.ImpoundLocation[3])
	SetBlipSprite (blip, Config.ImpoundBlip.sprite)
	SetBlipDisplay(blip, Config.ImpoundBlip.display)
	SetBlipScale  (blip, Config.ImpoundBlip.scale)
	SetBlipColour (blip, Config.ImpoundBlip.color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang['impound_blip'])
	EndTextCommandSetBlipName(blip)
end)


Citizen.CreateThread(function()
	for k, v in pairs(Config.Garages) do
		local blip = AddBlipForCoord(v.menuPos[1], v.menuPos[2], v.menuPos[3])
		SetBlipSprite (blip, Config.GaragesBlip.sprite)
		SetBlipDisplay(blip, Config.GaragesBlip.display)
		SetBlipScale  (blip, Config.GaragesBlip.scale)
		SetBlipColour (blip, Config.GaragesBlip.color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString((Lang['garage_blip']):format(k))
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterCommand("geth", function()
	print(GetEntityHeading(player))
end)