require "prefabutil"

-- assets
local itemassets = {
    Asset("ANIM", "anim/painmagnet_item.zip"),
    Asset("ATLAS", "images/inventoryimages/inventoryicon.xml"),
    Asset("IMAGE", "images/inventoryimages/inventoryicon.tex")
}
local assets = {
    Asset("ANIM", "anim/painmagnet.zip"),
    Asset("ANIM", "anim/ui_chest_4x5.zip")
}

local PAINMAGNET_HEALTH = GetModConfigData("pm_hp", KnownModIndex:GetModActualName("Pain Magnet"))
local PAINMAGNET_REGEN = 1
local PAINMAGNET_RANGE = GetModConfigData("pm_range", KnownModIndex:GetModActualName("Pain Magnet"))
local PAINMAGNET_DAMAGE = GetModConfigData("pm_attack", KnownModIndex:GetModActualName("Pain Magnet"))
local PAINMAGNET_FOOD_HEAL_RATIO = GetModConfigData("pm_food_ratio", KnownModIndex:GetModActualName("Pain Magnet"))
local PAINMAGNET_ATTACK_PERIOD = 0.2
local PAINMAGNET_DAMAGE_REDUCTION = 0.3

-- painmagnet_item ondeploy
local function ondeploy(inst, pt, deployer)
    local structure = SpawnPrefab("painmagnet")
    if structure then
        structure.Transform:SetPosition(pt:Get())
        inst:Remove() -- Remove the item after deployment
    end
end

-- painmagnet_item
local function itemfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    -- inst:AddTag("structure")
    inst.AnimState:SetBank("painmagnet_item")
    inst.AnimState:SetBuild("painmagnet_item")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "inventoryicon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/inventoryicon.xml"

    inst:AddTag("deploykititem")
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)

    return inst
end

local AGGRO_MUST_TAGS = { "_combat" }
local AGGRO_CANT_TAGS = { "INLIMBO", "player", "eyeturret", "engineering","beehive","hive","spiderden" }
-- painmagnet AttractAggro()
local function AttractAggro(inst)
    print("Starting aggro task.")
    if not inst.components.combat then
        return
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local range = PAINMAGNET_RANGE or 15

    local ents = TheSim:FindEntities(x, y, z, range, AGGRO_MUST_TAGS, AGGRO_CANT_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() and v.components.combat and inst.components.combat:CanTarget(v) then
            v.components.combat:GiveUp()
            v.components.combat:SetTarget(inst)
            v.components.health:DoDelta(-PAINMAGNET_DAMAGE, nil, "painmagnet")
        end
    end
end


local function StartAggroTask(inst)
    local period = PAINMAGNET_ATTACK_PERIOD or 5
    inst:DoPeriodicTask(period, AttractAggro)
end

-- painmagnet onhammered
local function onhammered(inst, worker)
    if worker and worker:HasTag("player") then
        for i = 1, 4 do
            inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
        end
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("wood")
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
        inst:Remove()
    end
end

-- painmagnet
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("painmagnet")
    inst.AnimState:SetBuild("painmagnet")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("painmagnet") end
        return inst
    end

    inst:AddTag("structure")
    inst:AddTag("container")

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PAINMAGNET_HEALTH)
    inst.components.health:StartRegen(PAINMAGNET_REGEN, 1)

    inst:AddComponent("combat")
    StartAggroTask(inst)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("painmagnet")
    inst.components.container.onopenfn = function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
    -- override GetAllItems
    inst.components.container.GetAllItems = function(self)
        local collected_items = {}
        for k, v in pairs(self.slots) do
            if v ~= nil then
                if v.components.stackable then
                    local stack_size = v.components.stackable:StackSize()
                    for i = 1, stack_size do
                        table.insert(collected_items, v)
                    end
                else
                    table.insert(collected_items, v)
                end
            end
        end
        return collected_items
    end
    inst.components.container.onclosefn = function(inst)
        local items = inst.components.container:GetAllItems()
        local total_hunger = 0

        for _, item in ipairs(items) do
            if item.components.edible and item.components.edible.hungervalue then
                if item.components.edible.hungervalue > 0 then
                    total_hunger = total_hunger + PAINMAGNET_FOOD_HEAL_RATIO*item.components.edible.hungervalue
                end
            end

            inst.components.container:RemoveItem(item)
            item:Remove()
        end

        local current_health = inst.components.health.currenthealth
        local max_health = inst.components.health.maxhealth
        local new_health = math.min(current_health + total_hunger * 10, max_health) -- 确保不超过最大血量
        inst.components.health:SetCurrentHealth(new_health)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    -- local function turnon(inst)
    --     inst:Remove()
    --     GLOBAL.SpawnPrefab("painmagnet_item_item").Transform:SetPosition(inst.Transform:GetWorldPosition())
    -- end
    -- inst:AddComponent("machine")
    -- inst.components.machine.turnonfn = turnon

    return inst
end

return Prefab("painmagnet_item", itemfn, itemassets),
    Prefab("painmagnet", fn, assets),
    MakePlacer("painmagnet_placer", "painmagnet", "painmagnet", "idle")
