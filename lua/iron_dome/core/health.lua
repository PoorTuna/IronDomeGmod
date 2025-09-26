-- lua/iron_dome/core/health.lua
function TakeBlastDamage(ent, dmginfo)
    if not dmginfo:IsDamageType(DMG_BLAST) then return end
    local newHealth = ent:Health() - dmginfo:GetDamage()
    ent:SetHealth(newHealth)
    if newHealth <= 0 then ExplodeEntity(ent) end
end

function ExplodeEntity(ent)
    if not IsValid(ent) or ent.Exploded then return end
    ent.Exploded = true
    local explosion = ents.Create("env_explosion")
    if not IsValid(explosion) then return end
    explosion:SetPos(ent:GetPos())
    explosion:SetKeyValue("iMagnitude", "500")
    explosion:SetKeyValue("iRadiusOverride", "300")
    explosion:SetOwner(ent:GetOwner() or ent)
    explosion:Spawn()
    explosion:Fire("Explode", 0, 0)
    ent:Remove()
end
