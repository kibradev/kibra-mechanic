local Menudemi = false 

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        local Sleep = 3000
        local PlayerPed = PlayerPedId()
        local PlayerCoord = GetEntityCoords(PlayerPed)
        for mch, mechanic in pairs(KIBRA.Mechanic) do
            local DistanceMenu = #(PlayerCoord - mechanic["PatronMenu"])
            local DistanceMarket = #(PlayerCoord - mechanic["MekanikShop"])
            if ESX.PlayerData.job and ESX.PlayerData.job.name == mechanic["MekanikJob"] and ESX.PlayerData.job.grade_name == mechanic["ErisimRutbe"] then
               if DistanceMenu < 2 then
                    Sleep = 2
                    DrawMarker(2, mechanic["PatronMenu"].x, mechanic["PatronMenu"].y, mechanic["PatronMenu"].z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 180, 0, 200, false, true, 2, false, false, false, false)
                    ESX.DrawText3D(mechanic["PatronMenu"].x, mechanic["PatronMenu"].y, mechanic["PatronMenu"].z + 0.1, '~g~E~w~ - Patron Menüsü')
                    if IsControlJustPressed(0, 38) then
                        OpenPatronMenu(mechanic)
                    end
                end
                if  ESX.PlayerData.job and ESX.PlayerData.job.name == mechanic["MekanikJob"] then
                    if DistanceMarket < 5 then
                        Sleep = 2
                        DrawMarker(2, mechanic["MekanikShop"].x, mechanic["MekanikShop"].y, mechanic["MekanikShop"].z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 180, 0, 200, false, true, 2, false, false, false, false)
                        ESX.DrawText3D(mechanic["MekanikShop"].x, mechanic["MekanikShop"].y, mechanic["MekanikShop"].z + 0.1, '~g~E~w~ - Mekanik Marketi')
                        if IsControlJustPressed(0, 38) then
                            OpenMekanikShop(i)
                        end
                    end
                end
            end
        end
        Citizen.Wait(Sleep)
    end
end)

OpenMekanikShop = function(i)
    local ShopItems = {}
    ShopItems.label = "Mekanik Marketi Shop"
    ShopItems.items = KIBRA.MechanicShop.Items
    ShopItems.slots = #KIBRA.MechanicShop.Items
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "MekanikShop"..math.random(11111,99999), ShopItems)
end

RegisterNetEvent("MechanicMenuOpen", function()
    OpenPatronMenu(mechanic)
end)

function OpenPatronMenu(mechanic)
        local elements = {
            {label = "Mekanik Araçları", value = 'mekanikarac'},
            {label = "Mekanik Deposu", value = 'mekanikdepo'},
            {label = "Patron Menüsü", value = 'patron'}
        }
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'KibraDevWorks', {
            title    = mechanic["MekanikName"]..' Patron Menüsü',
            align    = 'top-right',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'mekanikarac' then
                OpenCarMenu(mechanic)
            elseif data.current.value == 'mekanikdepo' then
                TriggerServerEvent("inventory:server:OpenInventory", "stash", "MekanikDepo_"..mechanic["MekanikName"])
                TriggerEvent("inventory:client:SetCurrentStash", "MekanikDepo_"..mechanic["MekanikName"])
            elseif data.current.value == 'patron' then
                    TriggerEvent('esx_society:openBossMenu', mechanic["MekanikJob"], function(data, menu)
                    menu.close()
                end)
            end
        end, function(data, menu)
            menu.close()
    end)
end

RegisterCommand("mechanicmenu", function()
    for ge,mechanic in pairs(KIBRA.Mechanic) do
        if  ESX.PlayerData.job and ESX.PlayerData.job.name == mechanic["MekanikJob"] then
            print("Meslek Var")
            OpenF6Menu(mechanic)
        else
            print("Meslek Yok")
        end
    end
end)

RegisterKeyMapping('mechanicmenu', 'F6 Mekanik Aksiyonları', 'keyboard', 'f6')

function OpenCarMenu(mechanic)
    ESX.UI.Menu.CloseAll()
    for ge = 1, #mechanic["Araclar"], 1 do
	local elements = {}
		table.insert(elements, {label =  mechanic["Araclar"][ge].Label,	value = mechanic["Araclar"][ge].Model})
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'araclar',
			{
			title    = mechanic["MekanikName"].." Araçları",
			align    = 'left',
			elements = elements
			},
			function(data, menu)
		ESX.Game.SpawnVehicle(data.current.value, mechanic["AracSpawn"], 90.0, function(vehicle)
			local playerPed = PlayerPedId()
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			ESX.UI.Menu.CloseAll()
		end)
		end, function(data2, menu2)
		menu2.close()
		end)
    end
end


function OpenF6Menu(mechanic)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'f6menu', {
		title    = "Mekanik Menüsü",
		align    = 'top-left',
		elements = {
			{label = "Fatura Kes",       value = 'billing'},
			{label = "Araç Kapısını Aç", value = 'hijack_vehicle'},
			{label = "Aracı Tamir Et",   value = 'fix_vehicle'},
			{label = "Aracı Temizle",    value = 'clean_vehicle'},
			{label = "Aracı Çek",        value = 'del_vehicle'},
			{label = "Aracı Dorseye Yerleştir", value = 'dep_vehicle'},
			{label = "Obje Yerleştir",   value = 'object_spawner'}
	}}, function(data, menu)
		if isBusy then return end

		if data.current.value == 'billing' then
			TriggerEvent("kibra-mechanic:client:FaturaKes")
		elseif data.current.value == 'hijack_vehicle' then
			TriggerEvent("kibra-mechanic:client:KapiAc")
		elseif data.current.value == 'fix_vehicle' then
			TriggerEvent("kibra-mechanic:client:AracTamir")
		elseif data.current.value == 'clean_vehicle' then
			TriggerEvent("kibra-mechanic:client:AracTemizle")
		elseif data.current.value == 'del_vehicle' then
			TriggerEvent("kibra-mechanic:client:AracBagla")
		elseif data.current.value == 'dep_vehicle' then
			TriggerEvent("kibra-mechanic:client:Dorse")
		elseif data.current.value == 'object_spawner' then
			local playerPed = PlayerPedId()
			if IsPedSittingInAnyVehicle(playerPed) then
                ESX.Notify("Başarısız","Aracın içindeyken bunu yapamazsınız!",3000,"error")
				return
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions_spawn', {
				title    = "Obje Yerleştirme",
				align    = 'top-left',
				elements = {
					{label = "Koni", value = 'prop_roadcone02a'},
					{label = "Tamir Kutusu",  value = 'prop_toolchest_01'}
			}}, function(data2, menu2)
				local model   = data2.current.value
				local coords  = GetEntityCoords(playerPed)
				local forward = GetEntityForwardVector(playerPed)
				local x, y, z = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
					z = z - 2.0
				elseif model == 'prop_toolchest_01' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("kibra-mechanic:client:Dorse")
AddEventHandler("kibra-mechanic:client:Dorse", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, true)

    local towmodel = GetHashKey('flatbed')
    local isVehicleTow = IsVehicleModel(vehicle, towmodel)

    if isVehicleTow then
        local targetVehicle = ESX.Game.GetVehicleInDirection()

        if CurrentlyTowedVehicle == nil then
            if targetVehicle ~= 0 then
                if not IsPedInAnyVehicle(playerPed, true) then
                    if vehicle ~= targetVehicle then
                        AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        CurrentlyTowedVehicle = targetVehicle
                        ESX.Notify("Başarılı","Araç başarıyla bağlandı!",3000,"success")
                    else
                        ESX.Notify("Başarısız","Kendi cekinizi bağlayamazsınız!")
                    end
                end
            else
                ESX.Notify("Başarısız","Bağlanacak araç yok!",3000,"error")
            end
        else
            AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            DetachEntity(CurrentlyTowedVehicle, true, true)

            

            CurrentlyTowedVehicle = nil
            ESX.Notify("Başarılı","Araç başarıyla ayrıldı!",3000,"success")
        end
    else
        ESX.Notify("Başarısız","Aracı çekebilmek için dorseye ihtiyacınız var!",3000,"error")
    end
end)

RegisterNetEvent("kibra-mechanic:client:AracBagla")
AddEventHandler("kibra-mechanic:client:AracBagla", function()
    local playerPed = PlayerPedId()

    if IsPedSittingInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if GetPedInVehicleSeat(vehicle, -1) == playerPed then
            ESX.Notify("Başarılı","Araç başarıyla çekildi",3000,"success")
            ESX.Game.DeleteVehicle(vehicle)
        else
            ESX.Notify("Başarısız","Sürücü koltuğunda olmalısınız!",3000,"error")
        end
    else
        local vehicle = ESX.Game.GetVehicleInDirection()

        if DoesEntityExist(vehicle) then
            exports['aex-bar']:taskBar(10000,'Araç Çekiliyor')
            ESX.Notify("Başarılı","Araç başarıyla çekildi",3000,"success")
            ESX.Game.DeleteVehicle(vehicle)
        else
            ESX.Notify("Başarısız","Aracın yakınında olmalısınız!",3000,"error")
        end
    end
end)


RegisterNetEvent("kibra-mechanic:client:AracTemizle")
AddEventHandler("kibra-mechanic:client:AracTemizle", function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    local coords    = GetEntityCoords(playerPed)

    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.Notify("Geçersiz","Aracın içindeyken bunu yapamazsın!",3000,"error")
        return
    end

    if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
        Citizen.CreateThread(function()
            exports['aex-bar']:taskBar(20000,'Araç Temizleniyor')
            SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasksImmediately(playerPed)

            ESX.Notify("Başarılı","Araç Başarıyla Temizlendi!",3000,"success")
            isBusy = false
        end)
    else
        ESX.Notify("Bulunamadı","Yakında Araç Yok",3000,"error")
    end
end)

RegisterNetEvent("kibra-mechanic:client:AracTamir")
AddEventHandler("kibra-mechanic:client:AracTamir", function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    local coords    = GetEntityCoords(playerPed)

    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.Notify("Geçersiz","Aracın içindeyken bunu yapamazsın!",3000,"error")
        return
    end

    if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
        Citizen.CreateThread(function()
            exports['aex-bar']:taskBar(30000,'Araç Tamir Ediliyor')
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            ClearPedTasksImmediately(playerPed)

            ESX.Notify("Başarılı","Araç Tamir Edildi!",3000,"success")
            isBusy = false
        end)
    else
        ESX.ShowNotification(_U('no_vehicle_nearby'))
    end
end)

RegisterNetEvent('kibra-mechanic:client:TamirKitiKullan')
AddEventHandler('kibra-mechanic:client:TamirKitiKullan', function()
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
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			Citizen.CreateThread(function()
                exports['aex-bar']:taskBar(30000,'Araç Tamir Ediliyor')
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.Notify("Başarılı","Aracı başarıyla tamir ettiniz!",3000,"success")
			end)
		end
	end
end)

RegisterNetEvent("kibra-mechanic:client:FaturaKes")
AddEventHandler("kibra-mechanic:client:FaturaKes", function()
    for k,mechanic in pairs(KIBRA.Mechanic) do
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
        title = "Fatura Miktarı"
    }, function(data, menu)
        local amount = tonumber(data.value)

        if amount == nil or amount < 0 then
            ESX.Notify("Geçersiz!","Geçersiz Miktar Girdiniz!",3000,"error")
        else
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.Notify("Bulunamadı!","Yakında kimse yok!",3000,"error")
            else
                menu.close()
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_'..mechanic["MekanikJob"], mechanic["MekanikJob"], amount)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end
end)

RegisterNetEvent("kibra-mechanic:client:KapiAc")
AddEventHandler("kibra-mechanic:client:KapiAc", function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local coords = GetEntityCoords(playerPed)

    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.Notify("Geçersiz","Aracın içindeyken bunu yapamazsın!",3000,"error")
        return
    end

    if DoesEntityExist(vehicle) then
        isBusy = true
        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
        Citizen.CreateThread(function()
            exports['aex-bar']:taskBar(20000,'Aracın Kapısını Açıyorsun')
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ClearPedTasksImmediately(playerPed)

            ESX.Notify("Başarılı","Aracın kilidini kırdınız!",3000,"success")
            isBusy = false
        end)
    else
        ESX.Notify("Başarısız!","Yakında Araç Yok!",3000,"error")
    end
end)

-- Citizen.CreateThread(function()
--     for f,mechanic in pairs(KIBRA.Mechanic) do
--     local blip = AddBlipForCoord(mechanic["PatronMenu"])
-- 	SetBlipSprite (blip, mechanic["BlipId"])
-- 	SetBlipDisplay(blip, 4)
-- 	SetBlipScale  (blip, 0.5)
-- 	SetBlipColour (blip, mechanic["BlipColor"])
-- 	SetBlipAsShortRange(blip, true)
-- 	BeginTextCommandSetBlipName('STRING')
-- 	AddTextComponentSubstringPlayerName(mechanic["MekanikName"])
-- 	EndTextCommandSetBlipName(blip)
--     end
-- end)