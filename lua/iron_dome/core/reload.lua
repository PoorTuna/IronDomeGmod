-- lua/iron_dome/core/reload.lua
function HandleReload(dome)
    if not dome.MissilesLeft then dome.MissilesLeft = 20 end
    if dome.Reloading then return false end
    if dome.MissilesLeft <= 0 then
        dome.Reloading = true
        sound.Play("buttons/lever4.wav", dome:GetPos(), 75, 100, 1)
        timer.Simple(10, function()
            if IsValid(dome) then
                dome.MissilesLeft = 20
                dome.Reloading = false
            end
        end)
        return false
    end
    return true
end
