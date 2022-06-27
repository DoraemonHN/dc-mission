local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = QBCore.Functions.GetPlayerData()
CanTakeDailyMission = false 
CanTakeHourlyMission = false 

-- Handles state right when the player selects their character and location.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent('dc-mission:server:registerMissions')
end)

-- Resets state on logout, in case of character change.
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
  PlayerData = {}
end)

-- Handles state when PlayerData is changed at all.
RegisterNetEvent('QBCore:Player:SetPlayerData', function(_PlayerData)
    PlayerData = _PlayerData
end)

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         TriggerServerEvent('dc-mission:server:registerMissions')
--     end
-- end)

RegisterNetEvent("dc-mission:client:TakeDailyMission", function()
    QBCore.Functions.TriggerCallback('dc-mission:server:CheckDailyMission', function(daily, month, mission)
        if daily ~= nil and month ~= nil then
            if mission ~= 'nomission' then
                local Random_Mission = math.random(1, #Config.Daily_Mission)
                TriggerServerEvent("dc-mission:server:TakeDailyMission", Random_Mission, daily, month)
                TriggerEvent("dc-mission:client:CheckProgress", "dailymission")
            else
                QBCore.Functions.Notify("Bạn đã nhận nhiệm vụ rồi mà?", 'error', 2500)
            end    
        else
            QBCore.Functions.Notify("Có lỗi xảy ra!", 'error')
        end
    end)
end)

RegisterNetEvent("dc-mission:client:TakeHourlyMission", function()
    QBCore.Functions.TriggerCallback('dc-mission:server:CheckHoursMission', function(hours, mission)
        if hours ~= nil then
            if mission ~= 'nomission' then
                local Random_Mission = math.random(1, #Config.Hourly_Mission)
                TriggerServerEvent("dc-mission:server:TakeHourlyMission", Random_Mission, hours)
                TriggerEvent("dc-mission:client:CheckProgress", "hourlymission")
            else
                QBCore.Functions.Notify('Bạn đã nhận nhiệm vụ rồi mà?', 'error', 2500)
            end
        else
            QBCore.Functions.Notify("Có lỗi xảy ra!", 'error')
        end
    end)
end)


RegisterNetEvent("dc-mission:client:TakeHiddenMission", function(mission)
    local ID = Config.Hidden_Mission[mission].id
    QBCore.Functions.TriggerCallback("dc-mission:server:CheckHiddenMission", function(result)
        if result then
            QBCore.Functions.TriggerCallback("dc-mission:server:CheckHiddenMissionProgress", function(check)
                if check then
                    QBCore.Functions.Notify("Bạn đã nhận được nhiệm vụ đặc biệt "..Config.Hidden_Mission[mission].name..", nhiệm vụ này yêu cầu bạn "..Config.Hidden_Mission[mission].label..".")
                    TriggerServerEvent("dc-mission:server:TakeHiddenMission", ID)
                    TriggerEvent("dc-mission:client:CheckHiddenProgress", mission)
                else
                    QBCore.Functions.Notify("Bạn đã nhận nhiệm vụ rồi", 'error', 2500)
                end
            end)
        else
            QBCore.Functions.Notify("Bạn đã làm nhiệm vụ này rồi!", 'error', 2500)
        end
    end)
end)

RegisterNetEvent("dc-mission:client:CheckProgress", function(type)
    if type == 'hourlymission' then
        QBCore.Functions.TriggerCallback("dc-mission:server:CheckMission", function(mission)
            if mission ~= nil then
                if mission ~= 'nomission' then
                    TriggerServerEvent("dc-mission:server:CheckProgress", type, Config.Hourly_Mission[mission].required, Config.Hourly_Mission[mission].reward_money)
                else
                    QBCore.Functions.Notify("Bạn chưa nhận nhiệm vụ", 'error', 1500)
                end
            else
                QBCore.Functions.Notify("Đã có lỗi xảy ra", 'error', 2500)
            end
        end, type)
    elseif type = 'dailymission' then
        QBCore.Functions.TriggerCallback("dc-mission:server:CheckMission", function(mission)
            if mission ~= nil then
                if mission ~= 'nomission' then
                    TriggerServerEvent("dc-mission:server:CheckProgress", type, Config.Daily_Mission[mission].required, Config.Daily_Mission[mission].reward_money)
                else
                    QBCore.Functions.Notify("Bạn chưa nhận nhiệm vụ", 'error', 1500)
                end
            else
                QBCore.Functions.Notify("Đã có lỗi xảy ra", 'error', 2500)
            end
        end, type)
    end
end)

RegisterNetEvent("dc-mission:client:CheckHiddenProgress", function(key)
    if Config.Hidden_Mission[key] then
        QBCore.Functions.TriggerCallback("dc-mission:server:CheckHiddenProgress", function(mission)
            if mission then 
                TriggerServerEvent("dc-mission:server:CheckProgress", Config.Hidden_Mission[key].id, Config.Hidden_Mission[key].required, Config.Hidden_Mission[key].reward_item, Config.Hidden_Mission[key].reward_money)
            end
        end, key)
    end 
end)
