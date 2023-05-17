if Config.Framework == "ESX" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "QBCore" then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == "CUSTOM" then
        -- Add your own framework here
    else
        print("Invalid framework, please check your config")
    return
end

Citizen.CreateThread(function()
if Config.ImpoundGarages == nil then
    print("Invalid impound garage locations, please check your config")
    return
end
for k, v in pairs(Config.ImpoundGarages) do
    v = v.Coords
  if Config.EnableBlips then
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, Config.BlipSettings.Sprite)
    SetBlipDisplay(blip, Config.BlipSettings.Display)
    SetBlipScale(blip, Config.BlipSettings.Scale)
    SetBlipColour(blip, Config.BlipSettings.Colour)
    SetBlipAsShortRange(blip, Config.BlipSettings.ShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Translations[Config.Language].ImpoundGarage)
    EndTextCommandSetBlipName(blip)
    end
    local Wait = 1500
    while true do
      Citizen.Wait(Wait)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true) < Config.InteractDistance then
      Wait = 1
    else
      Wait = 1500
    end
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true) < Config.InteractDistance then
      DrawText3Ds(v.x, v.y, v.z, Config.Translations[Config.Language].ImpoundGarage3DText)
      if IsControlJustPressed(0, Config.KeyToOpenMenu) then
          OpenImpoundMenu(k)
        end
      end
    end
  end
end)

function OpenImpoundMenu(garage)
  local playerId = GetPlayerServerId(PlayerId())
  TriggerServerEvent("mester_impoundgarageGetVehicles", playerId, garage)
end

RegisterNetEvent("mester_impoundgarageVehicles", function(vehicles, garage)
  for k, v in pairs(vehicles) do
    v.name = GetDisplayNameFromVehicleModel(v.model)
  end
  SendNUIMessage({
    type = "open",
    vehicles = vehicles,
    translations = Config.Translations[Config.Language],
    garage = garage
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("exit", function()
  SendNUIMessage({
    type = "exit",
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback("pay", function(data)
  local plate = data.plate
  local garage = data.garage
  SendNUIMessage({
    type = "exit",
    })
    SetNuiFocus(false, false)
    TriggerServerEvent("mester_impoundgaragePay", plate, garage)
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end

RegisterNetEvent("mester_impoundNotify", function(text, type)
  if text and type then
  mester_impoundNotify(text, type)
  end
end)

RegisterNetEvent("mester_impoundgarageSpawnVehicle", function(vehicle, garage)
if Config.Framework == "ESX" then
ESX.Game.SpawnVehicle(vehicle.model, Config.ImpoundGarages[garage].SpawnCoords, Config.ImpoundGarages[garage].Heading, function(yourVehicle)
  TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
  SetVehicleProperties(yourVehicle, vehicle)
  NetworkFadeInEntity(yourVehicle, true, true)
  SetModelAsNoLongerNeeded(vehicle["model"])
  SetEntityAsMissionEntity(yourVehicle, true, true)    
  SetVehicleHasBeenOwnedByPlayer(yourVehicle, true)    
  end)
elseif Config.Framework == "QBCore" then
QBCore.Functions.SpawnVehicle(vehicle.model, function(yourVehicle)
  TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
  SetVehicleProperties(yourVehicle, vehicle)
  NetworkFadeInEntity(yourVehicle, true, true)
  SetModelAsNoLongerNeeded(vehicle["model"])
  SetEntityAsMissionEntity(yourVehicle, true, true)    
  SetVehicleHasBeenOwnedByPlayer(yourVehicle, true)    
    end)
elseif Config.Framework == "CUSTOM" then
  local yourVehicle = CreateVehicle(vehicle.model, Config.ImpoundGarages[garage].SpawnCoords, Config.ImpoundGarages[garage].Heading, true, false) --This should work with any framework, replace with your own spawn vehicle function if needed 
  TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)
  SetVehicleProperties(yourVehicle, vehicle)
  NetworkFadeInEntity(yourVehicle, true, true)
  SetModelAsNoLongerNeeded(vehicle["model"])
  SetEntityAsMissionEntity(yourVehicle, true, true)
  SetVehicleHasBeenOwnedByPlayer(yourVehicle, true) 
  end
end)

function SetVehicleProperties(yourVehicle, vehicle)
  if Config.Framework == "ESX" then
  ESX.Game.SetVehicleProperties(yourVehicle, vehicle)
elseif Config.Framework == "QBCore" then
  QBCore.Functions.SetVehicleProperties(yourVehicle, vehicle)
elseif Config.Framework == "CUSTOM" then
  if not SetVehiclePropertiesCustom(yourVehicle, vehicle) then
    print("Config.Framework is set to CUSTOM but SetVehiclePropertiesCustom is not found!")
    return
  end
end

  SetVehicleEngineHealth(yourVehicle, vehicle["engineHealth"] and vehicle["engineHealth"] + 0.0 or 1000.0)
  SetVehicleBodyHealth(yourVehicle, vehicle["bodyHealth"] and vehicle["bodyHealth"] + 0.0 or 1000.0)
SetVehicleFuelLevel(yourVehicle, vehicle["fuelLevel"] and vehicle["fuelLevel"] + 0.0)
exports["LegacyFuel"]:SetFuel(yourVehicle, vehicle["fuelLevel"] and vehicle["fuelLevel"] + 0.0)


  if vehicle["windows"] then
      for windowId = 1, 13, 1 do
          if vehicle["windows"][windowId] == false then
              SmashVehicleWindow(yourVehicle, windowId)
          end
      end
  end

  if vehicle["tyres"] then
      for tyreId = 1, 7, 1 do
          if vehicle["tyres"][tyreId] ~= false then
              SetVehicleTyreBurst(yourVehicle, tyreId, true, 1000)
          end
      end
  end

  if vehicle["doors"] then
      for doorId = 0, 5, 1 do
          if vehicle["doors"][doorId] ~= false then
              SetVehicleDoorBroken(vehicle, doorId - 1, true)
          end
      end
  end
end