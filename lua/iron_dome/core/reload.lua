-- lua/iron_dome/core/reload.lua
include("iron_dome/consts.lua")

function HandleReload(dome)
    if not dome.MissilesLeft then dome.MissilesLeft = IronDomeConsts.MissilesPerReload end
    if dome.Reloading then return false end
    if dome.MissilesLeft <= 0 then
        dome.Reloading = true
        sound.Play(IronDomeConsts.LeverSoundPath, dome:GetPos(), 75, 100, 1)
        timer.Simple(10, function()
            if IsValid(dome) then
                dome.MissilesLeft = IronDomeConsts.MissilesPerReload
                dome.Reloading = false
            end
        end)
        return false
    end
    return true
end
