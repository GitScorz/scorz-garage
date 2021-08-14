player = nil
coords = {}
curVehicle = nil
driver = nil

Citizen.CreateThread(function()
    while true do
		  player = GetPlayerPed(-1)
		  coords = GetEntityCoords(player)
      curVehicle = GetVehiclePedIsIn(player, false)
      driver = GetPedInVehicleSeat(curVehicle, -1)
      Citizen.Wait(500)
    end
end)

RegisterCommand("f", function()
  FreezeEntityPosition(player, false)
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      local sleep = true
      local isInMenu = false

      --## JOB GARAGES ##--

      if Config.EnablePoliceGarage then
        local pdGarageDistance = Vdist(coords.x, coords.y, coords.z, Config.PoliceGarage[1], Config.PoliceGarage[2], Config.PoliceGarage[3])
        if PlayerData.job and PlayerData.job.name == 'police' then
          if pdGarageDistance <= Config.DrawDistance and pdGarageDistance >= 2.0 then
            sleep = false
            DrawMarker(20, Config.PoliceGarage[1], Config.PoliceGarage[2], Config.PoliceGarage[3], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8, 0.8, 1.0, 252, 40, 3, 100, false, true, 2, false, false, false, false)
          elseif pdGarageDistance <= 2.0 then
            sleep = false
            DrawText3Ds(Config.PoliceGarage[1], Config.PoliceGarage[2], Config.PoliceGarage[3], Lang['access_garage'])
            if IsControlJustPressed(0, Config.AcessGarageKey) then
              FreezeEntityPosition(player, true)
              OpenPDGarage()
            end
          end
        end
      end

      if Config.EnableEMSGarage then
        local emsGarageDistance = Vdist(coords.x, coords.y, coords.z, Config.EMSGarage[1], Config.EMSGarage[2], Config.EMSGarage[3])
        if PlayerData.job and PlayerData.job.name == 'ambulance' then
          if emsGarageDistance <= Config.DrawDistance and emsGarageDistance >= 2.0 then
            sleep = false
            DrawMarker(20, Config.EMSGarage[1], Config.EMSGarage[2], Config.EMSGarage[3], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8, 0.8, 1.0, 252, 40, 3, 100, false, true, 2, false, false, false, false)
          elseif emsGarageDistance <= 2.0 then
            sleep = false
            DrawText3Ds(Config.EMSGarage[1], Config.EMSGarage[2], Config.EMSGarage[3], Lang['access_garage'])
            if IsControlJustPressed(0, Config.AcessGarageKey) then
              FreezeEntityPosition(player, true)
              OpenEMSGarage()
            end
          end
        end
      end
      --## JOB GARAGES END ##--

      --## IMPOUND ##--
      if Config.EnableImpound then
        local ImpoundDistance = Vdist(coords.x, coords.y, coords.z, Config.ImpoundLocation[1], Config.ImpoundLocation[2], Config.ImpoundLocation[3])
        if ImpoundDistance <= Config.DrawDistance and ImpoundDistance >= 2.0 then
          sleep = false
          DrawMarker(20, Config.ImpoundLocation[1], Config.ImpoundLocation[2], Config.ImpoundLocation[3], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8, 0.8, 1.0, 252, 40, 3, 100, false, true, 2, false, false, false, false)
        elseif ImpoundDistance <= 2.0 then
          sleep = false
          DrawText3Ds(Config.ImpoundLocation[1], Config.ImpoundLocation[2], Config.ImpoundLocation[3], Lang['access_impound'])
          if IsControlJustPressed(0, Config.AccessImpoundKey) then
            FreezeEntityPosition(player, true)
            exports['progressBars']:startUI(2500, 'GETTING IMPOUNDED VEHICLES')
            Wait(2500)
            ImpoundThing()
          end
        end
      end
      --## IMPOUND END ##--

      --## GARAGES ##-
      for k, v in pairs(Config.Garages) do
        local garageMenuDistance = Vdist(coords.x, coords.y, coords.z, v.menuPos[1], v.menuPos[2], v.menuPos[3])
        local garageSaveDistance = Vdist(coords.x, coords.y, coords.z, v.savePos[1], v.savePos[2], v.savePos[3])

        if not IsPedInAnyVehicle(PlayerPedId()) then
          if garageMenuDistance <= Config.DrawDistance and garageMenuDistance >= 2.0 then
              sleep = false
              DrawMarker(20, v.menuPos[1], v.menuPos[2], v.menuPos[3], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.8, 0.8, 1.0, 252, 40, 3, 100, false, true, 2, false, false, false, false)
          elseif garageMenuDistance <= 2.0 then
            sleep = false
            DrawText3Ds(v.menuPos[1], v.menuPos[2], v.menuPos[3], Lang['access_garage'])
            if IsControlJustPressed(0, Config.AcessGarageKey) then
              OpenGarageMenu(k, v.spawnPos, v.spawnHeading)
              FreezeEntityPosition(player, true)
            end
          end
        end

        if IsPedInAnyVehicle(PlayerPedId()) and driver == PlayerPedId() then
          if garageSaveDistance <= 12.0 then
            sleep = false
            DrawMarker(27, v.savePos[1], v.savePos[2], v.savePos[3]-0.965, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 1.0, 252, 40, 3, 100, false, true, 2, true, false, false, false)
          end
          if garageSaveDistance <= 4.0 then
            sleep = false
            DrawText3Ds(v.savePos[1], v.savePos[2], v.savePos[3], Lang['save_car_garage'])
            if IsControlJustPressed(0, Config.SaveGarageCarKey) then
              local vehicle = GetVehiclePedIsUsing(PlayerPedId())
              FreezeEntityPosition(vehicle, true)

              if DoesEntityExist(vehicle) then
                local vehicleProps = GetVehicleProperties(vehicle)
                ESX.TriggerServerCallback("scorz_garage:validateVehicle", function(valid)
                  if valid then
                    OpenSaveMenu(k, vehicle)
                  else
                    notify(Lang['dont_own_vehicle'])
                    FreezeEntityPosition(vehicle, false)
                  end
              end, vehicleProps)
            end
            end
          end
        end
      end
      --## GARAGES END ##-

      --## SLEEP THREAD ##--
      if sleep then
        Citizen.Wait(500)
      end

    end
end)

function ImpoundThing()

    local elements = {}

    ESX.TriggerServerCallback("scorz_garage:getPlayerVehiclesOut", function(outCars)
      if #outCars == 0 then
        notify(Lang['no_car_impounded'])
        FreezeEntityPosition(player, false)
      else
        for _,v in pairs(outCars) do
          local vehHash = v.vehicle.model
          local vehName = GetDisplayNameFromVehicleModel(vehHash)
          local vehLabel = GetLabelText(vehName)
          table.insert(elements, {label = vehLabel ..' | '.. v.plate.. ' | <span style="color:green;">$'.. Config.ImpoundPay ..'</span>', value = v.vehModel, vehicle = v.vehicle})
        end
 
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impounds_menu', {
          title = Lang['impound_blip'],
          align    = Config.MenuAlign,
          elements = elements
        }, function(data, menu)
          local vehProps = nil


          local vehVehicle = data.current.value

            ESX.TriggerServerCallback("scorz_garage:hasMoneyToPayImp", function(hasMoney)
                if hasMoney then

                  vehProps = data.current.vehicle

                  local vehicleProps = vehProps
                  if not vehicleProps["model"] then
                    vehicleProps = vehProps[1]
                  end
                    
                  local spawnpoint = Config.ImpoundSpawnPos
                  local spawnHeading = Config.ImpoundHeading
                  
                  -- fazer check da plate Config.Trim(vehicleProps["plate"]) e a plate retornada do menu data.current.plate

                  VehicleLoadTimer(vehicleProps["model"])
                  ESX.UI.Menu.CloseAll()
                  Wait(100)
                  FreezeEntityPosition(player, false)
                  
                  if not ESX.Game.IsSpawnPointClear(spawnpoint, 3.0) then 
                    return
                  end
                  
                  if not IsModelValid(vehicleProps["model"]) then
                    return
                  end

                  local color1 = vehicleProps.color1
                  local color2 = vehicleProps.color2

                  exports['progressBars']:startUI(2500, "GETTING VEHICLE")
                  Wait(2500)
                  ESX.Game.SpawnLocalVehicle(data.current.value, spawnpoint, spawnHeading, function(car)
                    vehVehicle = car

                    SetVehicleProperties(car, vehicleProps, color1, color2)
                    SetVehicleOnGroundProperly(car)
                    SetVehRadioStation(car, "OFF")
                    SetVehicleEngineOn(car, true, true, false)
                    TaskWarpPedIntoVehicle(player, car, -1)
                    TriggerServerEvent('scorz_garage:updateState', vehicleProps, 0, nil)
                    TriggerServerEvent("scorz_garage:payImp")
                    notify(Lang['you_paid_impound']:format(Config.ImpoundPay))
                  end)

                else
                  ESX.UI.Menu.CloseAll()
                  notify(Lang['insuficient_money'])
                  FreezeEntityPosition(player, false)
                end
            end)
        end, function(data, menu)
          menu.close()
          FreezeEntityPosition(player, false)
        end)
      end
  end)
end


function OpenGarageMenu(garage, spawn, spawnHeading)
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "garage_menu", {
    title    = Lang['garage_blip']:format(garage),
		align    = Config.MenuAlign,
		elements = {
     { label = "Garage Cars", value = "garage_cars" }
    }
  }, function(data, menu)
    local value = data.current.value

    -- START
    
    if value == 'garage_cars' then
      local elements = {}

      ESX.TriggerServerCallback('scorz_garage:getOwnedVehicles', function(ownedCars)
        if #ownedCars == 0 then
          notify(Lang['no_car_in_garage']:format(garage))
        else
          for _,v in pairs(ownedCars) do
            local vehHash = v.vehicle.model
            local vehName = GetDisplayNameFromVehicleModel(vehHash)
            local vehLabel = GetLabelText(vehName)
            table.insert(elements, {label = vehLabel .." | ".. v.plate, vehicle = v.vehicle})
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cars_menu', {
            title = Lang['garage_blip']:format(garage),
            align    = Config.MenuAlign,
            elements = elements
        }, function(data2, menu2)

            local vehProps = nil

            vehProps = data2.current.vehicle

            local vehicleProps = vehProps
            if not vehicleProps.model then
              vehicleProps = v.vehicle[1]
            end
                
            local spawnpoint = spawn

            ESX.UI.Menu.CloseAll()
            VehicleLoadTimer(vehicleProps["model"])
            FreezeEntityPosition(player, false)
              
            if not ESX.Game.IsSpawnPointClear(spawnpoint, 3.0) then 
              notify(Lang['spawn_not_clear'])
              return
            end
              
            if not IsModelValid(vehicleProps["model"]) then
              return
            end

            local color1 = vehicleProps.color1
            local color2 = vehicleProps.color2

            ESX.Game.SpawnLocalVehicle(vehicleProps["model"], spawnpoint, spawnHeading, function(car)
              vehVehicle = car

              SetVehicleProperties(car, vehicleProps, color1, color2)
              SetVehicleOnGroundProperly(car)
              SetVehRadioStation(car, "OFF")
              SetVehicleEngineOn(car, true, true, false)
              TaskWarpPedIntoVehicle(player, car, -1)
              TriggerServerEvent('scorz_garage:updateState', vehicleProps, 0, nil)
            end)
          end, function(data2, menu2)
            menu2.close()
          end)
        end
      end, garage)
    end
    -- END
  end, function(data, menu)
    menu.close()
    FreezeEntityPosition(player, false)
	end)
end

function OpenSaveMenu(garage, veh)
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "save_garage_menu", {
    title    = Lang['save_menu'],
		align    = Config.MenuAlign,
		elements = {
     { label = Lang['yes'], value = "yes" },
     { label = Lang['no'], value = "no" }
    }
  }, function(data, menu)
    local value = data.current.value

    if value == 'yes' then
      ESX.UI.Menu.CloseAll()
      FreezeEntityPosition(veh, false)
      SaveInGarage(garage)
      notify(Lang['stored_in_garage']:format(garage))
    end
    
    if value == 'no' then
      FreezeEntityPosition(veh, false)
      ESX.UI.Menu.CloseAll()
    end
  end, function(data, menu)
    menu.close()
    FreezeEntityPosition(veh, false)
	end)
end

--## PD FUNCTIONS ##--
function OpenPDGarage()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pd_garage_menu", {
    title    = Lang['police_garage'],
		align    = Config.MenuAlign,
		elements = {
     { label = "Garage", value = "open" },
     { label = "Store", value = "store"}
    }
  }, function(data, menu)
    local value = data.current.value

    if value == 'open' then
      pdCarsMenu()
    elseif value == 'store' then
      local veh,dist = ESX.Game.GetClosestVehicle(coords)
			if dist < 15 then
				DeleteEntity(veh)
				notify(Lang['stored_vehicle'])
			else
				notify(Lang['no_vehicles_nearby'])
			end
    end
  end, function(data, menu)
    menu.close()
    FreezeEntityPosition(player, false)
	end)
end

function pdCarsMenu()
  local cars = {}

  for k, vehicle in pairs(Config.PoliceCars) do
    local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))

    table.insert(cars, {
      label = ('%s'):format(vehicleLabel),
      name = vehicleLabel,
      model = vehicle.model
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pd_garage_cars", {
    title    = Lang['police_garage'],
		align    = Config.MenuAlign,
		elements = cars
  }, function(data, menu)
    
    local vehModel = data.current.model
    local plate = nil

    if vehModel then
      if ESX.Game.IsSpawnPointClear(Config.SpawnPDCarPos, 3.5) then

        if Config.UseVehicleShop then
          plate = exports['esx_vehicleshop']:GeneratePlate()
        else
          plate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
        end

        VehicleLoadTimer(vehModel)
        local veh = CreateVehicle(vehModel, Config.SpawnPDCarPos, 80, true, false)
        SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetVehicleNumberPlateText(veh,plate)

        SetVehicleDirtLevel(veh, 0.1)
        FreezeEntityPosition(player, false)
        ESX.UI.Menu.CloseAll()
      else
        notify(Lang['spawn_not_clear'])
      end
    end

  end, function(data, menu)
		menu.close()
	end)
end

--## EMS FUNCTIONS ##--
function OpenEMSGarage()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ems_garage_menu", {
    title    = Lang['ems_garage'],
		align    = Config.MenuAlign,
		elements = {
     { label = "Garage", value = "open" },
     { label = "Store", value = "store"}
    }
  }, function(data, menu)
    local value = data.current.value

    if value == 'open' then
      emsCarsMenu()
    elseif value == 'store' then
      local veh,dist = ESX.Game.GetClosestVehicle(coords)
			if dist < 4 then
				DeleteEntity(veh)
				notify(Lang['stored_vehicle'])
			else
				notify(Lang['no_vehicles_nearby'])
			end
    end
  end, function(data, menu)
    menu.close()
    FreezeEntityPosition(player, false)
	end)
end

function emsCarsMenu()
  local cars = {}

  for k, vehicle in pairs(Config.EMSCars) do
    local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))

    table.insert(cars, {
      label = ('%s'):format(vehicleLabel),
      name = vehicleLabel,
      model = vehicle.model
    })
  end

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), "ems_garage_cars", {
    title    = Lang['ems_garage'],
		align    = Config.MenuAlign,
		elements = cars
  }, function(data, menu)
    
    local vehModel = data.current.model
    local plate = nil

    if vehModel then
      if ESX.Game.IsSpawnPointClear(Config.SpawnEMSCarPos, 3.5) then

        if Config.UseVehicleShop then
          plate = exports['esx_vehicleshop']:GeneratePlate()
        else
          plate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
        end

        VehicleLoadTimer(vehModel)
        local veh = CreateVehicle(vehModel, Config.SpawnEMSCarPos, 62, true, false)
        SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetVehicleNumberPlateText(veh,plate)

        SetVehicleDirtLevel(veh, 0.1)
        FreezeEntityPosition(player, false)
        ESX.UI.Menu.CloseAll()
      else
        notify(Lang['spawn_not_clear'])
      end
    end

  end, function(data, menu)
		menu.close()
	end)
end


RegisterCommand("impound", function()
  if Config.EnableImpound then
    if PlayerData.job and PlayerData.job.name == 'police' --[[and PlayerData.job.name == 'towtruck']] then
      local veh, dist = ESX.Game.GetClosestVehicle(coords)
      if dist < 4 then
        exports['progressBars']:startUI(2500, "IMPOUNDING")
        Wait(2500)
        DeleteEntity(veh)
        notify(Lang['vehicle_impounded'])
      else
        notify(Lang['no_vehicles_nearby'])
      end
    else
      notify(Lang['cant_impound'])
    end
  end
end)