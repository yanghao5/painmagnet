name = "Pain Magnet"
author = "Yang Hao"
description = [[
20240310
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
configuration_options = {{
    -- GetModConfigData("")
    name = "userconfig",
    label = "Range",
    hover = "Action Range",
    options = {{
        data = "15",
        description = "15"
    }, {
        data = "25",
        description = "25"
    }, {
        data = "35",
        description = "35"
    }},
    default = "15"
}, {
    name = "Language",
    label = "Language",
    options = {{
        description = "English",
        data = "en"
    }, {
        description = "简体中文",
        data = "sch"
    }, },
    default = "en"
}}

