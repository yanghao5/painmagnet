require "prefabutil"

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
    {"MAGIC"}
)

-- Pain Magnet item
GLOBAL.STRINGS.NAMES.PAINMAGNET_ITEM = "Pain Magnet"
GLOBAL.STRINGS.RECIPE_DESC.PAINMAGNET = "Attracts Aggro"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET_ITEM = "I like it"

-- Pain Magnet
GLOBAL.STRINGS.NAMES.PAINMAGNET = "Pain Magnet"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET = "I like it"
