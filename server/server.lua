local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Rexshack-RedM/rsg-travel/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

        --versionCheckPrint('success', ('Current Version: %s'):format(currentVersion))
        --versionCheckPrint('success', ('Latest Version: %s'):format(text))
        
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

-----------------------------------------------------------------------
--Buy Ticket
-----------------------------------------------------------------------
RegisterServerEvent('rsg-travel:server:buyticket')
AddEventHandler('rsg-travel:server:buyticket', function(amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local totalcost = amount * Config.TicketCost
    local cashBalance = Player.PlayerData.money["cash"]

    if cashBalance >= totalcost then
        Player.Functions.RemoveMoney("cash", totalcost, "purchase-ticket")
        Player.Functions.AddItem('boatticket', amount)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['boatticket'], "add")

        TriggerClientEvent("rsg-travel:client:showNotification", src, true, Lang:t('label11')..totalcost, 'success') -- Signal client to show success notification
    else 
        TriggerClientEvent("rsg-travel:client:showNotification", src, false, Lang:t('label12'), 'error') -- Signal client to show error notification
    end
end)

-----------------------------------------------------------------------
--Remove Ticket
-----------------------------------------------------------------------
RegisterNetEvent('rsg-travel:server:removeItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)

--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()
