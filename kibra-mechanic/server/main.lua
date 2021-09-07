ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for kevase,mechanic in pairs(KIBRA.Mechanic) do
TriggerEvent('esx_phone:registerNumber', mechanic["MekanikJob"], "Mekanik - Araç Tamir", true, true)
TriggerEvent('esx_society:registerSociety', mechanic["MekanikJob"], mechanic["MekanikJob"], 'society_'..mechanic["MekanikJob"], 'society_'..mechanic["MekanikJob"], 'society_'..mechanic["MekanikJob"], {type = 'private'})
end

ESX.RegisterUsableItem('tamirkiti', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tamirkiti', 1)

	TriggerClientEvent('kibra-mechanic:client:TamirKitiKullan', _source)
    TriggerClientEvent('okokNotify:Alert', _source, "Başarılı", "Tamir Kiti Kullandınız", 3000, 'success')
end)