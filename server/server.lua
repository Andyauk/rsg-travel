local QRCore = exports['qr-core']:GetCoreObject()

RegisterServerEvent('rsg-travel:server:buyticket')
AddEventHandler('rsg-travel:server:buyticket', function(price)
	local src = source
    local Player = QRCore.Functions.GetPlayer(src)
	local cashBalance = Player.PlayerData.money["cash"]
	if cashBalance >= price then
		Player.Functions.RemoveMoney("cash", price, "purchase-ticket")
		Player.Functions.AddItem('boatticket', 1)
		TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items['boatticket'], "add")
		QRCore.Functions.Notify(src, 'boat ticket bought for $'..price, 'success')
	else 
		QRCore.Functions.Notify(src, 'you don\'t have enough cash to do that!', 'error')
	end
end)

-- remove ticket
RegisterNetEvent('rsg-travel:server:removeItem', function(item, amount)
	local src = source
    local Player = QRCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
	TriggerClientEvent("inventory:client:ItemBox", src, QRCore.Shared.Items[item], "remove")
end)