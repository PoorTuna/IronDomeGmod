-- lua/iron_dome/core/target_filter.lua
function IsValidTarget(dome, ent)
    if not IsValid(ent) or ent == dome then return false end
    if ent:GetClass() == "iron_dome_missile" then return false end

    local class = ent:GetClass()
    if not (string.find(class,"missile") or string.find(class,"bomb") or string.find(class,"rocket")) then
        return false
    end

    if ent:IsPlayerHolding() then return false end
    if ent:GetPos().z <= dome:GetPos().z then return false end

    local tr = util.TraceLine({
        start = dome:GetPos() + Vector(0,0,50),
        endpos = ent:GetPos() + Vector(0,0,20),
        filter = dome,
        mask = MASK_SOLID_BRUSHONLY
    })
    if tr.HitWorld then return false end

    if IsTargetClaimed(ent) then return false end
    return true
end
