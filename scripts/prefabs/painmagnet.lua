require "prefabutil"

-- assets
local itemassets = {
    Asset("ANIM", "anim/painmagnet_item.zip"),
    Asset("ATLAS", "images/inventoryimages/inventoryicon.xml"),
    Asset("IMAGE", "images/inventoryimages/inventoryicon.tex")
}
local assets = {
    Asset("ANIM", "anim/painmagnet.zip")
}
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

-- painmagnet onhammered
-- local function onhammered(inst, worker)
--     for i = 1, 4 do
--         inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
--     end
--     local fx = SpawnPrefab("collapse_small")
--     fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
--     fx:SetMaterial("wood")
--     inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
--     inst:Remove()
-- end

local PAINMAGNET_HEALTH=100000
local PAINMAGNET_REGEN=1

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
        return inst
    end

    inst:AddTag("structure")

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PAINMAGNET_HEALTH)
    inst.components.health:StartRegen(PAINMAGNET_REGEN, 1)

    -- inst:AddComponent("lootdropper")
    -- inst:AddComponent("workable")
    -- inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    -- inst.components.workable:SetWorkLeft(4) 
    -- inst.components.workable:SetOnFinishCallback(onhammered)

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
