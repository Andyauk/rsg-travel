local RSGCore = exports['rsg-core']:GetCoreObject()

-- buy ticket
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
        RSGCore.Functions.Notify(src, 'boat ticket bought for $'..totalcost, 'success')
    else 
        RSGCore.Functions.Notify(src, 'you don\'t have enough cash to do that!', 'error')
    end
end)

-- remove ticket
RegisterNetEvent('rsg-travel:server:removeItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)