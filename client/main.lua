local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local callerData = nil
local menu = nil

local function Notify(message, type, length)
    if GetResourceState("ox_lib") ~= 'missing' then
        lib.notify({title = "MH Uber", description = message, type = type})
    else
        QBCore.Functions.Notify({text = "MH Uber", caption = message}, type, length)
    end
end

local function CalculateUberPrice(from, to)
    local route = CalculateTravelDistanceBetweenPoints(from.x, from.y, from.z, to.x, to.y, to.z)
    local price = math.floor((route / 1000) * Config.RitPrice)
    return price
end

local function UberMenu()
    QBCore.Functions.TriggerCallback("mh-uber:server:GetUberDrivers", function(drivers)
        if #drivers >= 1 then
            local options = {}
            for k, v in pairs(drivers) do
                options[#options + 1] = {
                    id = v.source,
                    title = Lang:t('info.uber', {fullname = v.fullname}),
                    description = Lang:t('info.click_to_send_sms'),
                    arrow = false,
                    onSelect = function()
                        QBCore.Functions.TriggerCallback("mh-uber:server:sendNewMail", function(mailSend)
                            if mailSend.status then
                                Notify(mailSend.message, "success", 5000)
                            elseif not mailSend.status then
                                Notify(mailSend.message, "error", 5000)
                            end
                        end, {uberId = v.source, location = GetEntityCoords(PlayerPedId())})
                    end
                }
            end
            table.sort(options, function(a, b) return a.id < b.id end)
            options[#options + 1] = {title = Lang:t('info.close'), icon = "fa-solid fa-stop", description = '', arrow = false, onSelect = function() end}
            lib.registerContext({id = 'menu', title = "MH Uber", icon = "fa-solid fa-car", options = options})
            lib.showContext('menu')
        else
            Notify(Lang:t('info.no_ubers_online'), "error", 5000)
        end
    end)
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerServerEvent('mh-uber:server:onjoin')
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = {}
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('mh-uber:server:onjoin')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onduty)
    PlayerData.job.onduty = onduty
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('mh-uber:client:ToggleDuty', function()
    QBCore.Functions.TriggerCallback("mh-uber:server:HasVehicleForTheJob", function(hasVehicle)
        if hasVehicle then
            if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                Notify(Lang:t('info.not_in_vehicle'), "error", 5000)
            elseif GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                TriggerServerEvent('QBCore:ToggleDuty')
            end
        elseif not hasVehicle then
            Notify(Lang:t('info.wrong_vehicle', {category = Config.AllowedVehiclesCategory}), "error", 5000)
        end
    end)
end)

RegisterNetEvent('mh-uber:client:onjoin', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    Wait(50)
    if PlayerData.job and PlayerData.job.onduty then
        TriggerServerEvent('QBCore:ToggleDuty')
    end
end)

RegisterNetEvent('mh-uber:client:notify', function(message, type, length)
    Notify(message, type, length)
end)

RegisterNetEvent('mh-uber:client:ReceiveMail', function(message)
    if message ~= nil and type(message) == 'string' then Notify(message, "success", 15000) end
end)

RegisterNetEvent('mh-uber:client:setLocation', function(data)
    if type(data) == 'table' and type(data.callerId) == 'number' and data.callerId > 0 then
        QBCore.Functions.TriggerCallback("mh-uber:server:ReceiveMail", function(result)
            if result.status and result.message ~= nil then
                SetNewWaypoint(data.coords.x, data.coords.y)
                Notify(result.message, "success", 5000)
                callerData = {callerId = data.callerId, startCoords = data.coords}
            end
        end, data.callerId)
    end
end)

RegisterCommand(Config.OpenMenuCommand, function() UberMenu() end, false)
RegisterKeyMapping(Config.OpenMenuCommand, Lang:t('info.open_uber_menu'), 'keyboard', Config.OpenMenuButton)

RegisterNetEvent('mh-uber:client:sendMail', function(data)
    if type(data) == 'table' then TriggerServerEvent('qb-phone:server:sendNewMail', data) end
end)

RegisterNetEvent('mh-uber:client:BillClient', function()
    if callerData == nil then
        Notify("You had no job so you can't bill a client.", 'error', 5000)
    else
        local price = CalculateUberPrice(callerData.startCoords, GetEntityCoords(PlayerPedId()))
        QBCore.Functions.TriggerCallback("mh-uber:server:BillClient", function(result)
            if result.status then
                Notify(result.message, 'success', 5000)
                callerData = nil
            elseif not result.status then
                Notify(result.message, 'error', 5000)
            end
        end, {callerId = callerData.callerId, price = price})
    end
end)

RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
        if PlayerData.job.name == 'uber' then
            if menu ~= nil then exports['qb-radialmenu']:RemoveOption(menu) menu = nil end
            local UbernMenu = {id = 'uberclientmenu', title = Lang:t('info.uber_job'), icon = 'car', items = {}}
            local title, icon = nil, nil
            if PlayerData.job.onduty then title, icon = Lang:t('onduty.enable disable'), "toggle-on" else title, icon = Lang:t('onduty.enable'),"toggle-off" end
            UbernMenu.items[#UbernMenu.items + 1] = {id = "uberdutymenu", title = title, icon = icon, type = 'client', event = 'mh-uber:client:ToggleDuty', shouldClose = true}
            UbernMenu.items[#UbernMenu.items + 1] = {id = "uberdutymenu", title = "Bill Client", icon = icon, type = 'client', event = 'mh-uber:client:BillClient', shouldClose = true}
            if #UbernMenu.items == 0 then if menu then exports['qb-radialmenu']:RemoveOption(menu) menu = nil end else menu = exports['qb-radialmenu']:AddOption(UbernMenu, menu) end
        end
    end
end)