local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('dc-mission:server:CheckDailyMission', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local DailyMission = 0
    local Month = 1
    local HaveMission = nil

    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ? AND daily_mission = ?", {cid, 'nomission'})
    if result then
        DailyMission = result.daily
        Month = result.month
        HaveMission = 'nomission'
    else
        DailyMission = 0
        Month = 0
        HaveMission = 'nomission'
    end

    cb(DailyMission, Month, HaveMission)
end)

QBCore.Functions.CreateCallback('dc-mission:server:CheckHoursMission', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local HourlyMission = 0
    local HaveMission = nil

    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ? AND hour_mission = ?", {cid, 'nomission'})
    if result then
        HourlyMission = result.hour
        HaveMission = 'nomission'
    else
        HourlyMission = 0
        HaveMission = 'nomission'
    end

    cb(HourlyMission, HaveMission)
end)

QBCore.Functions.CreateCallback('dc-mission:server:CheckMission', function(source, cb, type)
    local mission = nil
    if type == 'dailymission' then
        local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ?", {cid})
        if result then
            mission = tonumber(result.daily_mission)
        else
            mission = nil
        end
    elseif type == 'hourlymission' then
        local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ?", {cid})
        if result then
            mission = tonumber(result.hour_mission)
        else
            mission = nil
        end
    end

    cb(mission)
end)

RegisterNetEvent('dc-mission:server:registerMissions', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local cid = Player.PlayerData.citizenid
    local name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ?", {cid})
    if not result then
        MySQL.Async.insert('INSERT INTO missions (citizenid, name, daily, hour, hidden) VALUES (:citizenid, :name, :daily, :hour, :hidden)', {citizenid = cid, name = name, daily = 0, hour= 0, hidden = 0})
    end
end)

RegisterNetEvent("dc-mission:server:TakeDailyMission", function(mission, daily, month)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local time_table = os.date("*t")
    if daily == tonumber(time_table.day) then
        if month ~= tonumber(time_table.month) then
            TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận được nhiệm vụ hàng giờ mang tên "..Config.Daily_Mission[mission].name.." nhiệm vụ này yêu cầu bạn "..Config.Daily_Mission[mission].label.."", "success") 
            MySQL.Async.insert("UPDATE missions SET daily =?, month = ?, daily_mission = ? WHERE citizenid = ?", {time_table.day, time_table.month, mission, Player.PlayerData.citizenid})
        else
            TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận nhiệm vụ ngày rồi, vui lòng đợi qua ngày mới", "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận được nhiệm vụ hàng giờ mang tên "..Config.Daily_Mission[mission].name.." nhiệm vụ này yêu cầu bạn "..Config.Daily_Mission[mission].label.."", "success") 
        MySQL.Async.insert("UPDATE missions SET daily =?, month = ?, daily_mission = ? WHERE citizenid = ?", {time_table.day, time_table.month, mission, Player.PlayerData.citizenid})
    end
end)

RegisterNetEvent("dc-mission:server:TakeHourlyMission", function(mission, hours)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local time_table = os.date("*t")
    if hours ~= time_table.hour then
        TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận được nhiệm vụ hàng giờ mang tên "..Config.Hourly_Mission[mission].name.." nhiệm vụ này yêu cầu bạn "..Config.Hourly_Mission[mission].label.."", "success")
        MySQL.Async.insert("UPDATE missions SET hour = ?, hour_mission = ? WHERE citizenid = ?", {time_table.hour, mission, Player.PlayerData.citizenid})
    else 
        TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận nhiệm vụ giờ rồi, vui lòng đợi một chút nữa", "error") 
    end
end)

RegisterNetEvent("dc-mission:server:TakeHiddenMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then 
        MySQL.Async.insert("UPDATE missions SET hidden_mission = ? WHERE citizenid = ?", {mission, Player.PlayerData.citizenid})
    end
end)

QBCore.Functions.CreateCallback('dc-mission:server:CheckHiddenMission', function(source, cb)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ? AND hidden = ?", {Player.PlayerData.citizenid, 0})
    if result then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('dc-mission:server:CheckHiddenMissionProgress', function(source, cb, id)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ? AND hidden = ? AND hidden_mission = ?", {Player.PlayerData.citizenid, 0, 'nomission'})
    if result then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('dc-mission:server:CheckHiddenProgress', function(source, cb, key)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.Sync.fetchScalar("SELECT * FROM missions WHERE citizenid = ? AND hidden_mission = ?", {Player.PlayerData.citizenid, key})
    if result then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("dc-mission:server:CheckProgress", function(type, requiredTable, RewardItems, RewardMoney)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local text = ""
    local reward_item_text = ""
    local progress = {}
    local progress_text = ""
    if hasMissionItems(src, requiredTable) then 
        completeMission(src, type, RewardItems, RewardMoney)
    else 
        for k, v in pairs (requiredTable) do
            if Player.Functions.GetItemByName(k) then
                progress[k] = Player.Functions.GetItemByName(k).amount 
            else 
                progress[k] = 0
            end  
            if progress[k] < v then 
                progress_text = "["..(progress[k]).."/" .. v .. "]"
            else 
                progress_text = "Hoàn thành"
            end            
            text = text.." - ".. QBCore.Shared.Items[k]["label"] .. " "..progress_text.."<br>"
        end
        for k, v in pairs (RewardItems) do
            reward_item_text = reward_item_text.." - "..v.." ".. QBCore.Shared.Items[k]["label"] .. " "..reward_item_text.."<br>"
        end
        TriggerClientEvent('QBCore:Notify', source, "Bạn hiện tại đã thu thập được:<br>"..text.."<br>Phần thưởng:<br>"..reward_item_text.."", "error")
    end
end)


function hasMissionItems(source, CostItems)
	local Player = QBCore.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v) then
				return false
			end
		else
			return false
		end
	end
	for k, v in pairs(CostItems) do  
		Player.Functions.RemoveItem(k, v)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[k], "remove")
	end
	return true
end

function completeMission(source, type, RewardItems, RewardMoney)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
    if type == "dailymission" then 
        MySQL.Async.insert("UPDATE missions SET daily_mission = ? WHERE citizenid = ?", {0, Player.PlayerData.citizenid})
    elseif type == "hourlymission" then 
        MySQL.Async.insert("UPDATE missions SET hour_mission = ? WHERE citizenid = ?", {0, Player.PlayerData.citizenid})
    else
        MySQL.Async.insert("UPDATE missions SET hidden = ?, hidden_mission = ? WHERE citizenid = ?", {'done', 'nomission', Player.PlayerData.citizenid})
    end

	if RewardItems ~= nil then
		for k, v in pairs(RewardItems) do
			Player.Functions.AddItem(k, v)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[k], "add")
		end
	end 
	
	if RewardMoney ~= nil then
        for k, v in pairs(RewardMoney) do 
		    Player.Functions.AddMoney(k, v)
        end
	end
	TriggerClientEvent('QBCore:Notify', source, "Chúc mừng bạn đã hoàn thành nhiệm vụ và nhận được phần thưởng.", "success")
end
