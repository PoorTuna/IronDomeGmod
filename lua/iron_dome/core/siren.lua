-- lua/iron_dome/core/siren.lua
include("iron_dome/consts.lua")
SirenHandlers = SirenHandlers or {}

function StartSiren(ent)
    if not ent.SirenPlaying and ent.SirenSound then
        ent.SirenSound:Play()
        ent.SirenSound:ChangeVolume(ent.SirenVolume, 0)
        ent.SirenSound:SetSoundLevel(IronDomeConsts.SirenSoundLevel)
        ent.SirenPlaying = true
    end
    ent.SirenStopTime = CurTime() + IronDomeConsts.SirenHoldTime
end

function StopSiren(ent)
    if ent.SirenSound then
        ent.SirenSound:Stop()
    end
    ent.SirenPlaying = false
    ent.SirenStopTime = nil
end

function UpdateSiren(ent, hasTarget)
    if hasTarget then
        StartSiren(ent)
    elseif ent.SirenPlaying and ent.SirenStopTime and CurTime() >= ent.SirenStopTime then
        StopSiren(ent)
    end
end