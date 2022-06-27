
Config = Config or {}

Config.Daily_NPC = {
    ped = "u_m_y_pogo_01",
    coords = vector4(182.99, -917.62, 30.69, 146.22),
}


Config.Hourly_NPC = {
    ped = "s_m_y_uscg_01",
    coords = vector4(185.31, -919.11, 30.69, 148.31),
}


Config.Daily_Mission = {
    {
        name = "Nông dân chăm chỉ",
        label = "Thu thập 10 bánh mì, 10 nước",
        required = {
            ["sandwich"] = 10,
            ["water_bottle"] = 10,
        },
        reward_item = {
            ["lockpick"] = 10,
        },
        reward_money = {
            ["cash"] = 5000,
            ["bank"] = 5000,
        }
    },
}

Config.Hourly_Mission = {
    {
        name = "Nông dân chăm chỉ",
        label = "Thu thập 10 bánh mì, 10 nước",
        required = {
            ["sandwich"] = 10,
            ["water_bottle"] = 10,
        },
        reward_item = {
            ["lockpick"] = 10,
        },
        reward_money = {
            ["cash"] = 5000,
            ["bank"] = 5000,
        }
    },
}

Config.Hidden_Mission = {
    {
        ped = "ig_car3guy1",
        coords = vector4(-8.61, -1032.35, 29.03, 328.58),
        min_time = 10,
        max_time = 20,

        id = "hidden_mission_1",
        name = "Nông dân chăm chỉ",
        label = "Thu thập 10 bánh mì, 10 nước",
        required = {
            ["sandwich"] = 10,
            ["water_bottle"] = 10,
        },
        reward_item = {
            ["lockpick"] = 10,
        },
        reward_money = {
            ["cash"] = 5000,
            ["bank"] = 5000,
        }
    },
    {
        ped = "ig_car3guy1",
        coords = vector4(-13.3, -1031.17, 28.97, 189.37),
        min_time = 10,
        max_time = 20,

        id = "hidden_mission_2",
        name = "Nông dân chăm chỉ",
        label = "Thu thập 10 bánh mì, 10 nước",
        required = {
            ["sandwich"] = 10,
            ["water_bottle"] = 10,
        },
        reward_item = {
            ["lockpick"] = 10, 
        },
        reward_money = {
            ["cash"] = 5000,
            ["bank"] = 5000,
        }
    },
}



