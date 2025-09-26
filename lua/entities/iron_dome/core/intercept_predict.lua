-- Solves for the intercept point in 3D, given shooter pos, missile speed, target pos & velocity
-- Returns the point the missile should aim at
function PredictInterceptExact(shooterPos, shooterSpeed, targetPos, targetVel)
    local dir = targetPos - shooterPos
    local a = targetVel:Dot(targetVel) - shooterSpeed^2
    local b = 2 * dir:Dot(targetVel)
    local c = dir:Dot(dir)

    local discriminant = b^2 - 4*a*c
    if discriminant < 0 then
        -- cannot hit, fallback: aim at current position
        return targetPos
    end

    local sqrtDisc = math.sqrt(discriminant)
    local t1 = (-b + sqrtDisc) / (2*a)
    local t2 = (-b - sqrtDisc) / (2*a)

    local t = math.min(t1, t2)
    if t < 0 then t = math.max(t1, t2) end
    if t < 0 then return targetPos end -- still negative, fallback

    return targetPos + targetVel * t
end
