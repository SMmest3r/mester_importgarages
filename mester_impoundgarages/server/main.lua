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

function DiscordLog(msg)
    local webhookstart = "https://discord.com/api/webhooks/"
    local webhookcheck = string.find(SConfig.Discord, webhookstart)
    if not webhookcheck then
        print("Invalid discord webhook, please check your config")
        return
    end
    if msg == nil or msg == '' then return FALSE end
	PerformHttpRequest(SConfig.Discord, function(err, text, headers) end, 'POST', json.encode({avatar = 'https://mest3rdevelopment.com/images/mesterlogo.png', content = msg}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("mester_impoundgaragesGetVehicles", function(player, garage)
    if Config.SQLGarageTable == nil then
        print("Invalid SQL table, please check your config")
        return
    end
    local license = GetPlayerIdentifiers(player)[2]
    local identifier = string.gsub(license, "license:", "")
    MySQL.Async.fetchAll(
    "SELECT * FROM "..Config.SQLGarageTable.." WHERE owner = @identifier AND impounded = @impounded",
    {
        ["@identifier"] = identifier,
        ["@impounded"] = 1
    },
    function(result)
    if result[1] == nil then
        TriggerClientEvent("mester_impoundNotify", player, Config.Translations[Config.Language].NoVehiclesInImpound, "DANGER")
        return
        end
    local vehicles = {}
    for k, v in pairs(result) do
        local vehicle = json.decode(v.vehicle)
        table.insert(vehicles, {
            plate = vehicle.plate,
            model = vehicle.model,
            price = Config.Price,
            })
        end
    TriggerClientEvent("mester_impoundgaragesVehicles", player, vehicles, garage)
    end)
end)

RegisterNetEvent("mester_impoundgaragesPay", function(plate, garage)
    moneyRemoved = false
    if plate == nil or plate == '' or garage == nil then return FALSE end
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getAccount('money').money > Config.Price then
            xPlayer.removeAccountMoney('money', Config.Price)
            moneyRemoved = true
        end
    elseif Config.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.PlayerData.money.cash > Config.Price then
            Player.Functions.RemoveMoney('cash', Config.Price)
            moneyRemoved = true
        end
    elseif Config.Framework == "CUSTOM" then
        if CustomRemoveImpoundFee(source, Config.Price) then
            moneyRemoved = true
        end
    else
        print("Invalid framework, please check your config")
        return
    end

    if moneyRemoved then
        moneyRemoved = false
    local license = GetPlayerIdentifiers(source)[2]
    local identifier = string.gsub(license, "license:", "")
    local player = source
    MySQL.Async.execute(
    "UPDATE "..Config.SQLGarageTable.." SET impounded = @impounded WHERE owner = @identifier AND plate = @plate",
    {
        ["@identifier"] = identifier,
        ["@plate"] = tostring(plate):gsub("%s+", ""),
        ["@impounded"] = 0
    },
    function(rewriteimpoundresult)
        end)
    TriggerClientEvent("mester_impoundNotify", source, string.format(Config.Translations[Config.Language].PaidImpoundFee, Config.Price), "success")
    DiscordLog(string.format(Config.Translations[Config.Language].PaidImpoundFeeLog, Config.Price) .. GetPlayerName(source) .. " (" .. source .. ")")
    MySQL.Async.fetchAll(
    "SELECT * FROM "..Config.SQLGarageTable.." WHERE owner = @identifier AND plate = @plate",
    {
        ["@identifier"] = identifier,
        ["@plate"] = tostring(plate):gsub("%s+", "")
    },
    function(result)
        if result[1] == nil then
            print("Error while fetching vehicle from database", plate, identifier)
            return
            end
        local vehicle = json.decode(result[1].vehicle)
        TriggerClientEvent("mester_impoundgaragesSpawnVehicle", player, vehicle, garage)
        end)
    else
        TriggerClientEvent("mester_impoundNotify", player, Config.Translations[Config.Language].NotEnoughMoney, "DANGER")
    end
end)

function GetPlayerJob()
    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer ~= nil then
            local job = xPlayer.job.name
            return job
        end
    elseif Config.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player ~= nil then
            local job = Player.PlayerData.job.name
            return job
        end
    elseif Config.Framework == "CUSTOM" then
        local job = CustomGetPlayerJob(source)
        if job ~= nil then
            return job
        end
    else
        print("Invalid framework, please check your config")
        return
    end
end

RegisterNetEvent("mester_impoundgaragesImpoundVehicle", function(plate)
    for k, v in pairs(Config.ImpoundJobs) do
        if v == GetPlayerJob(source) then
            local license = GetPlayerIdentifiers(source)[2]
            local identifier = string.gsub(license, "license:", "")
            MySQL.Async.execute(
            "UPDATE "..Config.SQLGarageTable.." SET impounded = @impounded WHERE owner = @identifier AND plate = @plate",
            {
                ["@identifier"] = identifier,
                ["@plate"] = tostring(plate):gsub("%s+", ""),
                ["@impounded"] = 1
            },
            function(rewriteimpoundresult)
                end)
            TriggerClientEvent("mester_impoundNotify", source, Config.Translations[Config.Language].ImpoundedVehicle, "success")
            DiscordLog(Config.Translations[Config.Language].ImpoundedVehicleLog .." " .. GetPlayerName(source) .. " (" .. source .. ")")
            return
        end
    end
end)

RegisterCommand(Config.RemoveFromImpoundGaragesCommand, function(source, args, rawCommand)
    if args[1] == nil or args[2] == nil then return end
    if GetPlayerName(args[1]) == nil then
        TriggerClientEvent("mester_impoundNotify", source, Config.Translations[Config.Language].PlayerNotFound, "DANGER")
        return
    end 
    local plate = table.concat(args, " ", 2) 
    for k, v in pairs(Config.AdminGroups) do
        if IsPlayerAceAllowed(source, v) then
            local license = GetPlayerIdentifiers(tonumber(args[1]))[2]
            local identifier = string.gsub(license, "license:", "")
    MySQL.Async.execute(
            "UPDATE "..Config.SQLGarageTable.." SET impounded = @impounded WHERE owner = @identifier AND plate = @plate",
            {
                ["@identifier"] = identifier,
                ["@plate"] = tostring(plate):gsub("%s+", ""),
                ["@impounded"] = 0
            },
            function(rewriteimpoundresult)
                end)
            TriggerClientEvent("mester_impoundNotify", source, Config.Translations[Config.Language].RemovedFromImpound, "success")
            DiscordLog(Config.Translations[Config.Language].RemovedFromImpoundLog .." ".. GetPlayerName(source) .. " (" .. source .. ")")
        end
    end
end)
