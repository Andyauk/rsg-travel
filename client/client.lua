local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
--From St.Denis to Guarma
-----------------------------------------------------------------------
Citizen.CreateThread(function()
    -- buy ticket
    exports['rsg-core']:createPrompt('stdenis-buy-ticket', vector3(2663.5056, -1543.155, 45.969764), RSGCore.Shared.Keybinds['ENTER'], Lang:t('label1'), {
        type = 'client',
        event = 'rsg-travel:client:buyticket',
        args = {},
    })
    -- travel to guarma
    exports['rsg-core']:createPrompt('stdenis-guarma', vector3(2663.5056, -1543.155, 45.969764), RSGCore.Shared.Keybinds['J'], Lang:t('label2'), { -- [J]
        type = 'client',
        event = 'rsg-travel:client:guarma_boat',
        args = {},
    })
    local PortBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, vector3(2663.5056, -1543.155, 45.969764))
    SetBlipSprite(PortBlip, 2033397166, 1)
    SetBlipScale(PortBlip, 0.2)   
end)
-----------------------------------------------------------------------
--From Guarma to St.Denis
-----------------------------------------------------------------------
Citizen.CreateThread(function()
    exports['rsg-core']:createPrompt('guarma-buy-ticket', vector3(1268.6583, -6851.772, 43.318504), RSGCore.Shared.Keybinds['ENTER'], Lang:t('label1'), {
        type = 'client',
        event = 'rsg-travel:client:buyticket',
        args = {},
    })
    exports['rsg-core']:createPrompt('guarma-stdenis', vector3(1268.6583, -6851.772, 43.318504), RSGCore.Shared.Keybinds['J'], Lang:t('label3'), {
        type = 'client',
        event = 'rsg-travel:client:stdenis_boat',
        args = {},
    })
    local PortBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, vector3(1268.6583, -6851.772, 43.318504))
    SetBlipSprite(PortBlip, 2033397166, 1)
    SetBlipScale(PortBlip, 0.2)
end)
-------------------------------------------------------------------------------------------
-- buy tickets
-------------------------------------------------------------------------------------------
RegisterNetEvent('rsg-travel:client:buyticket', function(money)
    local input = lib.inputDialog('Purchase Tickets', {
        { 
            label = Lang:t('label5'),
            description = '$'..Config.TicketCost..Lang:t('label4'),
            type = 'input',
            min = 1,
            max = 10,
            required = true,
            icon = 'fa-solid fa-hashtag'
        },
    })
    if not input then return end
    TriggerServerEvent("rsg-travel:server:buyticket", tonumber(input[1]))
end)
-----------------------------------------------------------------------
--Boat travel to Guarma
-----------------------------------------------------------------------
RegisterNetEvent("rsg-travel:client:guarma_boat")
AddEventHandler("rsg-travel:client:guarma_boat", function()
    local hasItem = RSGCore.Functions.HasItem('boatticket', 1)
    if hasItem then
        TriggerServerEvent('rsg-travel:server:removeItem', 'boatticket', 1)
        -- tp bateau
        DoScreenFadeOut(500)
        Wait(1000)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), 2652.301, -1586.043, 48.337059 -1, 183.40074)
        Wait(1500)
        DoScreenFadeIn(1800)
        SetCinematicModeActive(true)
        Wait(10000)
        Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, Lang:t('label6'), Lang:t('label7'), Lang:t('label8'))
        Wait(20000)
        -- tp guarma
        Citizen.InvokeNative(0x74E2261D2A66849A, 1)
        Citizen.InvokeNative(0xA657EC9DBC6CC900, 1935063277)
        Citizen.InvokeNative(0xE8770EE02AEE45C2, 1)
        -- fin tp
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), 1268.4954, -6853.771, 43.318477 -1, 241.44442)
        SetCinematicModeActive(false)
        ShutdownLoadingScreen()
    else
        lib.notify({ title = Lang:t('label9'), duration = 5000, type = 'error' })
    end
end)
-----------------------------------------------------------------------
--Boat travel to St Denis
-----------------------------------------------------------------------
RegisterNetEvent("rsg-travel:client:stdenis_boat")
AddEventHandler("rsg-travel:client:stdenis_boat", function()
    local hasItem = RSGCore.Functions.HasItem('boatticket', 1)
    if hasItem then
		TriggerServerEvent('rsg-travel:server:removeItem', 'boatticket', 1)
        DoScreenFadeOut(500)
        Wait(1000)
        -- tp bateau
        Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, Lang:t('label10'), Lang:t('label7'), Lang:t('label8'))
        Wait(30000)
        -- tp guarma
        Citizen.InvokeNative(0x74E2261D2A66849A, 0)
        Citizen.InvokeNative(0xA657EC9DBC6CC900, -1868977180)
        Citizen.InvokeNative(0xE8770EE02AEE45C2, 0)
        -- fin tp
        Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), 2663.2485, -1544.214, 45.969753 -1, 266.12268)
        ShutdownLoadingScreen()
        DoScreenFadeIn(1000)
        Wait(1000)
        SetCinematicModeActive(false)
    else
        lib.notify({ title = Lang:t('label9'), duration = 5000, type = 'error' })
    end
end)
-----------------------------------------------------------------------
--Toggle guarma world stuff
-----------------------------------------------------------------------
function SetGuarmaWorldhorizonActive(toggle)
    Citizen.InvokeNative(0x74E2261D2A66849A , toggle)
end

function SetWorldWaterType(waterType)
    Citizen.InvokeNative(0xE8770EE02AEE45C2, waterType)
end

function SetWorldMapType(mapType)
    Citizen.InvokeNative(0xA657EC9DBC6CC900, mapType)
end

function IsInGuarma()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    return x >= 0 and y <= -4096
end

local GuarmaMode = false

CreateThread(function()
    while true do
        Wait(500)

        if IsInGuarma() then
            if not GuarmaMode then
                SetGuarmaWorldhorizonActive(true);
                SetWorldWaterType(1);
                SetWorldMapType(`guarma`)
                GuarmaMode = true
            end
        else
            if GuarmaMode then
                SetGuarmaWorldhorizonActive(false);
                SetWorldWaterType(0);
                SetWorldMapType(`world`)
                GuarmaMode = false
            end
        end
    end
end)
-----------------------------------------------------------------------
--Ox notify calls from server
-----------------------------------------------------------------------
RegisterNetEvent('rsg-travel:client:showNotification')
AddEventHandler('rsg-travel:client:showNotification', function(success, message, type)
    if success then
        lib.notify({ title = message, duration = 5000, type = type })
    else
        lib.notify({ title = message, duration = 5000, type = type })
    end
end)
