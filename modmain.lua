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
-- UI
function widgetcreation(widgetanimbank, widgetpos, slot_x, slot_y, posslot_x, posslot_y)
    local containers = require("containers")
    local painmagnet = {
        widget = {
            slotpos = {},
            animbank = widgetanimbank,
            animbuild = widgetanimbank,
            pos = widgetpos,
            side_align_tip = 160,
        },
        type = "chest",
        itemtestfn = function(container, item, slot) 
            if item.components.edible then
               if  item.components.edible.foodtype == FOODTYPE.MEAT or item.components.edible.foodtype==FOODTYPE.VEGGIE then
                    return true
                end
            end
            return false
        end
    }
    
    for y = slot_y, 0, -1 do -- slot_y = 3
        for x = 0, slot_x do -- slot_x = 4
            table.insert(painmagnet.widget.slotpos, Vector3(80 * x - 346 * 2 + 90, 80 * y - 100 * 2 + 130, 0))
        end
    end
    
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, painmagnet.widget.slotpos ~= nil and #painmagnet.widget.slotpos or 0)
    containers.params.painmagnet = painmagnet
end

local Vector3 = GLOBAL.Vector3
widgetpos = Vector3(270, 150, 0)

-- slot_x = 4
-- slot_y = 3
-- posslot_x = 90
-- posslot_y = 130

widgetcreation("ui_chest_4x5", widgetpos, 4, 3, 90, 130)

-- Prefab
PrefabFiles = {
    "painmagnet"
}

AddRecipe2("painmagnet_item",
    {
        Ingredient("nightmarefuel", 5)
    },
    TECH.SCIENCE_ONE,
    {
        atlas = "images/inventoryimages/inventoryicon.xml",
        image = "inventoryicon.tex" 
    },
    {"MAGIC", "STRUCTURES"}
)



-- Pain Magnet item
GLOBAL.STRINGS.NAMES.PAINMAGNET_ITEM = "Pain Magnet"
GLOBAL.STRINGS.RECIPE_DESC.PAINMAGNET = "Attracts Aggro"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET_ITEM = "I like it"

-- Pain Magnet
GLOBAL.STRINGS.NAMES.PAINMAGNET = "Pain Magnet"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.PAINMAGNET = "I like it"
