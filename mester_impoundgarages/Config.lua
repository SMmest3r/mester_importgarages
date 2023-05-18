Config = {}

Config.Framework = "ESX" -- ESX or QBCore or CUSTOM

Config.Language = "EN" -- EN, HU, DE, CUSTOM

Config.ImpoundGarages = { -- Add your impound garages here
	[1] = {Coords = vector3(409.6714, -1623.5275, 29.2919), SpawnCoords = vector3(406.4394, -1643.9884, 29.2919), Heading = 226.1524},
}

Config.EnableBlips = true -- true or false

Config.BlipSettings = {
	Sprite = 67,
	Display = 4,
	Scale = 0.8,
	Colour = 3,
	ShortRange = false,
}

Config.InteractDistance = 3.0 -- Distance to interact with the impound garage

Config.KeyToOpenMenu = 38 -- Key to open the impound garage menu (Default: E) https://docs.fivem.net/docs/game-references/controls/

Config.Price = 5000 -- Price to get your vehicle out of the impound garage

Config.SQLGarageTable = "owned_vehicles" -- Change this if you are using a different table for vehicles

Config.ImpoundJobs = { -- Add your jobs here
	"police",
	"sheriff",
	"mechanic",
}

Config.RemoveFromImpoundGaragesCommand = "removefromimpound" -- Command to remove a vehicle from the impound garages (Admins only)

Config.AdminGroups = { -- Add your admin groups here
	"admin",
	"superadmin",
	"mod",
}

function mester_impoundNotify(text, type)
    --STANDALONE NOTIFICATION
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(true, true)
--DELETE THIS IF YOU WANT TO USE AN ANOTHER TYPE OF NOTIFICATION

-----------------------------------------EXAMPLES---------------------------------------------
--exports['okokNotify']:Alert("Scrapyard", text, 5000, type) --okok notify (PAID resource)
--TriggerEvent("mosh_UI:Open", type, text, "right", true) --Mosh UI / Notify (PAID resource)
--exports['mythic_notify']:DoHudText(type, text) --Mythic Notify (Free resource)
--exports["skeexsNotify"]:TriggerNotification({ ['type'] = type, ['message'] = text }) --skeexsNotify (Free resource)
--TriggerEvent('QBCore:Notify', text, type) --Default QBCore notifcation (Free resource - QB-Core)
--TriggerEvent('esx:showNotification', text) --Default ESX notification (Free resource -ESX)
----------------------------------------------------------------------------------------------
end

Config.Translations = {
	["EN"] = {
		ImpoundGarage = "Impound Garage",
		ImpoundGarage3DText = "Press ~g~[E]~s~ to open the impound garage",
		NoVehiclesInImpound = "You don't have any vehicles in the impound garage",
		Pay = "Pay & Exit",
		PaidImpoundFee = "You paid the impound fee of %s $",
		PaidImpoundFeeLog = "Paid impound fee of %s $",
		NotEnoughMoney = "You don't have enough money to get your vehicle out of the impound garage",
		ImpoundedVehicle = "Successfully impounded vehicle",
		ImpoundedVehicleLog = "Impounded vehicle",
		RemovedFromImpound = "Successfully removed vehicle from impound garage",
		RemovedFromImpoundLog = "Removed vehicle from impound garage",
	},

	["HU"] = {
		ImpoundGarage = "Lefoglaltak",
		ImpoundGarage3DText = "Nyomd meg az ~g~[E]~s~ gombot a lefoglaltak megtekintéséhez",
		NoVehiclesInImpound = "Nincs lefoglalt járműved",
		Pay = "Fizetés",
		PaidImpoundFee = "Kifizetted a lefoglalási díjat: %s $",
		PaidImpoundFeeLog = "Kifizette a lefoglalási díjat: %s $",
		NotEnoughMoney = "Nincs elég pénzed a jármű kivételéhez",
		ImpoundedVehicle = "Sikeresen lefoglaltad a járművet",
		ImpoundedVehicleLog = "Sikeresen lefoglalta a járművet",
		RemovedFromImpound = "Sikeresen eltávolítottad a járművet a lefoglaltak közül",
		RemovedFromImpoundLog = "Sikeresen eltávolította a járművet a lefoglaltak közül",
	},
	["DE"] = {
		ImpoundGarage = "Abschlepphof",
		ImpoundGarage3DText = "Drücke ~g~[E]~s~ um den Abschlepphof zu öffnen",
		NoVehiclesInImpound = "Du hast keine Fahrzeuge im Abschlepphof",
		Pay = "Bezahlen",
		PaidImpoundFee = "Du hast die Abschleppgebühr von %s $",
		PaidImpoundFeeLog = "Bezahlte Abschleppgebühr von %s $",
		NotEnoughMoney = "Du hast nicht genug Geld um dein Fahrzeug aus dem Abschlepphof zu holen",
		ImpoundedVehicle = "Fahrzeug erfolgreich abgeschleppt",
		ImpoundedVehicleLog = "Fahrzeug abgeschleppt",
		RemovedFromImpound = "Fahrzeug erfolgreich aus dem Abschlepphof entfernt",
		RemovedFromImpoundLog = "Fahrzeug aus dem Abschlepphof entfernt",
	},

	["CUSTOM"] = {
		ImpoundGarage = "",
		ImpoundGarage3DText = "",
		NoVehiclesInImpound = "",
		Pay = "",
		PaidImpoundFee = "",
		PaidImpoundFeeLog = "",
		NotEnoughMoney = "",
		ImpoundedVehicle = "",
		ImpoundedVehicleLog = "",
		RemovedFromImpound = "",
		RemovedFromImpoundLog = "",
	},
}
