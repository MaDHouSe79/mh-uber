local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("mh-uber:server:GetUberDrivers", function(source, cb, data)
    local src = source
    local caller = QBCore.Functions.GetPlayer(src)
    local ubers = {}
    for id, _ in pairs(QBCore.Players) do
        local uber = QBCore.Functions.GetPlayer(id)
        if uber and uber.PlayerData.job.name == 'uber' and uber.PlayerData.job.onduty then
            local name = uber.PlayerData.charinfo.firstname .. ' ' .. uber.PlayerData.charinfo.lastname
            local phone = uber.PlayerData.charinfo.phone
            ubers[#ubers + 1] = {source = id, fullname = name}
        end
    end
    cb(ubers)
end)

QBCore.Functions.CreateCallback("mh-uber:server:HasVehicleForTheJob", function(source, cb, data)
    local hasVehicle = false
    if Config.AllowedVehiclesCategory ~= -1 then
        local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles')
        for k, v in pairs(result) do
            if v.vehicle ~= nil then
                if type(Config.AllowedVehiclesCategory) == 'string' then
                    if Config.Vehicles[v.hash].category == Config.AllowedVehiclesCategory then
                        hasVehicle = true
                        break
                    end
                elseif type(Config.AllowedVehiclesCategory) == 'table' then
                    if Config.AllowedVehiclesCategory[Config.Vehicles[GetHashKey(v.vehicle)].category] then
                        hasVehicle = true
                        break
                    end
                end
            end
        end
    elseif Config.AllowedVehiclesCategory == -1 then
        hasVehicle = true
    end
    cb(hasVehicle)
end)

QBCore.Functions.CreateCallback("mh-uber:server:sendNewMail", function(source, cb, data)
    local src = source
    local result = {}
    local caller = QBCore.Functions.GetPlayer(src)
    if not caller then result = {status = false, message = Lang:t('info.caller_not_online')} return end
    local uber = QBCore.Functions.GetPlayer(data.uberId)
    if not uber then result = {status = false, message = Lang:t('info.uber_not_online')} return end
    if caller.PlayerData.citizenid ~= uber.PlayerData.citizenid then
        local mailData = {
            sender = Lang:t('main.sender', {fullname = caller.PlayerData.charinfo.firstname.." "..caller.PlayerData.charinfo.lastname}),
            subject = Lang:t('main.subject'),
            message = Lang:t('main.message', {phone = caller.PlayerData.charinfo.phone}),
            button = {enabled = true, buttonEvent = "mh-uber:client:setLocation", buttonData = {coords = data.location, callerId = src}}
        }
        TriggerClientEvent('mh-uber:client:sendMail', data.uberId, mailData)
        result = {status = true, message = Lang:t('info.mailsend')}
    else
        result = {status = false, message = Lang:t('info.can_not_call_your_self')}
    end
    cb(result)
end)

QBCore.Functions.CreateCallback("mh-uber:server:ReceiveMail", function(source, cb, callerId)
    local src = source
    if type(callerId) == 'number' and callerId ~= nil then
        if type(callerId) == 'number' then
            TriggerClientEvent('mh-uber:client:ReceiveMail', callerId, Lang:t('info.received_mail'))
            cb({status = true, message = "New waypoint added to your map"})
            return
        end
    end
    cb({status = false})
end)

QBCore.Functions.CreateCallback("mh-uber:server:BillClient", function(source, cb, data)
    local src = source
    local result = {status = true, message = nil}
    local uber = QBCore.Functions.GetPlayer(src)
    if not uber then result.status = false return end
    local billed = QBCore.Functions.GetPlayer(data.callerId)
    if not billed then result.status = false return end
    if result.status then
        local name = uber.PlayerData.charinfo.firstname .. ' ' .. uber.PlayerData.charinfo.lastname
        MySQL.insert('INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',{
            billed.PlayerData.citizenid, data.price, 'cash', uber.PlayerData.charinfo.firstname, uber.PlayerData.citizenid
        })
        TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
        TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'New Invoice Received')
        result.message = "Invoice Successfully Sent"
    elseif not result.status then
        result.message = "Invoice Not Sent"
    end
    cb(result)
end)

RegisterNetEvent('mh-uber:server:onjoin', function()
    local src = source
    TriggerClientEvent('mh-uber:client:onjoin', src)
end)