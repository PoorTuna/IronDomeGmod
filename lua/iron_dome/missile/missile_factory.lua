-- lua/iron_dome/core/missile_factory.lua
function CreateInterceptor(dome, target)
    if not IsValid(target) then return nil end
    local missile = ents.Create("iron_dome_missile")
    if not IsValid(missile) then return nil end

    missile:SetPos(dome:GetPos() + Vector(0,0,100))
    missile:SetOwner(dome)
    missile:Spawn()
    missile:SetTarget(target)

    local key = target:EntIndex()
    missile:CallOnRemove("ClearActiveMissile", function()
        UnclaimTarget(dome, target)
    end)

    dome.ActiveMissiles[key] = missile
    return missile
end
