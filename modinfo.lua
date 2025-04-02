name = "Pain Magnet"
author = "Yang Hao"
description = [[
Attracts monster attacks, an essential helper for solo gameplay.
]]
version = "1.0.0"
dst_compatible = true
forge_compatible = false
gorge_compatible = false
dont_starve_compatible = true
client_only_mod = false
all_clients_require_mod = true
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
api_version_dst = 10
priority = 10
mod_dependencies = {}
server_filter_tags = {}
configuration_options = { {
    -- GetModConfigData("")
    name = "pm_range",
    label = "Range", -- display in UI
    hover = "Action Range",
    options = { {
        data = "15",
        description = "15"
    }, {
        data = "25",
        description = "25"
    }, {
        data = "35",
        description = "35"
    } },
    default = "15"
}, {
    name = "pm_attack",
    label = "Attack",
    options = { {
        description = "0",
        data = 0
    }, {
        description = "10",
        data = 10
    }, {
        description = "20",
        data = 20
    }, },
    default = 0
}, {
    name = "pm_hp",
    label = "HP",
    options = { {
        description = "3000",
        data = 1000
    }, {
        description = "10000",
        data = 10000
    }, {
        description = "30000",
        data = 30000
    }, {
        description = "50000",
        data = 50000
    }, {
        description = "100000",
        data = 100000
    } },
    default = 30000
},
    {
        name = "pm_food_ratio",
        label = "Food Heal Ratio",
        options = { {
            description = "1",
            data = 1
        }, {
            description = "3",
            data = 3
        }, {
            description = "5",
            data = 5
        }, {
            description = "10",
            data = 10
        }, {
            description = "25",
            data = 25
        } },
        default = 10
    } }
