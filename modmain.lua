require "prefabutil"
local containers = require("containers")

GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

Assets = {
    Asset("ATLAS", "images/inventoryimages/inventoryicon.xml"),
    Asset("IMAGE", "images/inventoryimages/inventoryicon.tex"),
    Asset("ANIM", "anim/painmagnet_item.zip")
}

PrefabFiles = {
    "painmagnet"
}

AddRecipe2("painmagnet_item",
    {
        --Ingredient("monstermeat", 10),
        --Ingredient("meat", 10),
        --Ingredient("log", 30),
        Ingredient("nightmarefuel", 5)
    },
    TECH.SCIENCE_ONE,
    {
        -- placer = "painmagnet_placer",
        atlas = "images/inventoryimages/inventoryicon.xml",
        image = "inventoryicon.tex" 
    },
    {"MAGIC", "STRUCTURES"}
)

local params = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_4x5",
        animbuild = "ui_chest_4x5",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
    itemtestfn = function(container, item, slot) 
        return item.components.edible ~= nil
    end
}

for y = 3, 0, -1 do -- slot_y = 3
    for x = 0, 4 do -- slot_x = 4
        table.insert(params.widget.slotpos, Vector3(80 * x - 346 * 2 + 90, 80 * y - 100 * 2 + 130, 0))
    end
end

containers.params.painmagnet_storage = params

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, #params.widget.slotpos)

-- Pain Magnet item
GLOBAL.STRINGS.NAMES.PAINMAGNET_ITEM = "Pain Magnet"
GLOBAL.STRINGS.RECIPE_DESC.PAINMAGNET = "Attracts Aggro"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET_ITEM = "I like it"

-- Pain Magnet
GLOBAL.STRINGS.NAMES.PAINMAGNET = "Pain Magnet"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET = "I like it"
