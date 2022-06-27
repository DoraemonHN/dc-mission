local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("dc-mission:client:DailyMissionMenu", function()
    local DailyMissionMenu = {
        {
            header = "📒 Nhiệm Vụ Hàng Ngày",
            isMenuHeader = true
        },
    }
     
    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = "🗞 Nhận Nhiệm Vụ Hàng Ngày",
        txt = "Nhiệm vụ hàng ngày sẽ được reset khi qua ngày mới",
        params = { 
            event = "dc-mission:client:TakeDailyMission", 
        }
        
    }

    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = '🛎 Kiểm tra tiến độ',
        txt = "Kiểm tra tiến độ nhiệm vụ hiện tại của bạn",
        params = { 
            event = "dc-mission:client:CheckProgress",
            args = "dailymission", 
        }
    }
    
    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = "⬅ Thoát",
        txt = "",
        params = {
            event = "qb-menu:closeMenu",
        }
    }
    exports['qb-menu']:openMenu(DailyMissionMenu)
end)

RegisterNetEvent("dc-mission:client:HourlyMissionMenu", function()
    local HourlyMissionMenu = {
        {
            header = "📘 Nhiệm Vụ Hàng Giờ",
            isMenuHeader = true
        },
    }
     
    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = "🗞 Nhận Nhiệm Vụ Hàng Giờ",
        txt = "Nhiệm vụ hàng ngày sẽ được reset mỗi giờ",
        params = { 
            event = "dc-mission:client:TakeHourlyMission", 
        }
        
    }

    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = '🛎 Kiểm tra tiến độ',
        txt = "Kiểm tra tiến độ nhiệm vụ hiện tại của bạn",
        params = { 
            event = "dc-mission:client:CheckProgress",
            args = "hourlymission", 
        }
        
    }
    
    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = "⬅ Thoát",
        txt = "",
        params = {
            event = "qb-menu:closeMenu",
        }
    }
    exports['qb-menu']:openMenu(HourlyMissionMenu)
end)


RegisterNetEvent("dc-mission:client:HiddenMissionMenu", function(data)
    if GetClockHours() >= Config.Hidden_Mission[data.key].min_time and GetClockHours() <= Config.Hidden_Mission[data.key].max_time then
        local HiddenMissionMenu = {
            {
                header = "📙 Hidden Mission Menu",
                isMenuHeader = true
            },
        }
        
        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = '🗞 Nhận Nhiệm Vụ "'..Config.Hidden_Mission[data.key].name..'"',
            txt = "Đây là nhiệm vụ ẩn sẽ chỉ có thể làm 1 lần duy nhất",
            params = { 
                event = "dc-mission:client:TakeHiddenMission",
                args = data.key, 
            }
        }
        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = '🛎 Kiểm tra tiến độ',
            txt = "Kiểm tra tiến độ nhiệm vụ hiện tại của bạn",
            params = { 
                event = "dc-mission:client:CheckHiddenProgress",
                args = data.key, 
            }
            
        }
        
        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = "⬅ Thoát",
            txt = "",
            params = {
                event = "qb-menu:closeMenu",
            }
        }
        exports['qb-menu']:openMenu(HiddenMissionMenu)
    else 
        QBCore.Functions.Notify("Hiện tao đang bận, vui lòng đến vào lúc khác", "error")
    end 
end)

