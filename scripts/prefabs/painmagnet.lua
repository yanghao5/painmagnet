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

-- local function ondeploy(inst, pt, deployer)
--     local pot = SpawnPrefab("painmagnet", inst.linked_skinname, inst.skin_id )
--     if pot ~= nil then
--         pot.Physics:SetCollides(false)
--         pot.Physics:Teleport(pt.x, 0, pt.z)
--         pot.Physics:SetCollides(true)
--         pot.AnimState:PlayAnimation("place")
--         pot.AnimState:PushAnimation("idle_empty", false)
--         -- pot.SoundEmitter:PlaySound("dontstarve/common/together/portable/cookpot/place")
--         inst:Remove()
--         PreventCharacterCollisionsWithPlacedObjects(pot)
--     end
-- end

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

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "inventoryicon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/inventoryicon.xml"

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)

    return inst
end

-- painmagnet
local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    
    inst:AddTag("structure")

    inst.AnimState:SetBank("painmagnet")
    inst.AnimState:SetBuild("painmagnet")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4) -- Takes 4 hammer hits to destroy
    inst.components.workable.onfinish = function(inst, worker)
        inst:Remove()                       -- Simply remove for now; add loot later if desired
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
