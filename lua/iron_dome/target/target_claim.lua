-- lua/iron_dome/core/target_claim.lua
IronDome_GlobalTargets = IronDome_GlobalTargets or {}

function ClaimTarget(dome, target)
    local key = target:EntIndex()
    IronDome_GlobalTargets[target] = dome
    dome.ActiveTargets[key] = true
end

function UnclaimTarget(dome, target)
    local key = target:EntIndex()
    dome.ActiveTargets[key] = nil
    if IronDome_GlobalTargets[target] == dome then
        IronDome_GlobalTargets[target] = nil
    end
end

function IsTargetClaimed(target)
    return IronDome_GlobalTargets[target] ~= nil
end
