AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("iron_dome/consts.lua")

ENT.Speed = IronDomeConsts.MissileSpeed

function ENT:Initialize()
    self:SetModel("models/weapons/w_missile_launch.mdl")
        self:SetModelScale(2.5, 0)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(5)
        phys:SetDragCoefficient(0)
    end

    self.Target = nil
    self.Launched = false

    -- Add a trail
    util.SpriteTrail(
        self, 0, Color(255,255,255,200), false, 
        IronDomeConsts.MissileTrailStart, 
        IronDomeConsts.MissileTrailEnd, 
        1, 1/(IronDomeConsts.MissileTrailStart + IronDomeConsts.MissileTrailEnd)*0.5, 
        IronDomeConsts.MissileTrailTexture
    )
end

-- Assign target and calculate initial intercept
function ENT:SetTarget(target)
    if not IsValid(target) then return end
    self.Target = target

    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end

    -- Predict intercept using target position + velocity
    local targetPos = target:GetPos()
    local targetVel = target:GetVelocity()
    local dir = (targetPos + targetVel * 0.2 - self:GetPos()):GetNormalized() -- simple prediction

    phys:SetVelocity(dir * self.Speed)
    self:SetAngles(dir:Angle())

    self.Launched = true
end

function ENT:Think()
    if not IsValid(self.Target) or not self.Launched then
        self:Remove()
        return
    end

    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end

    -- Exact predictive intercept
    local interceptPoint = PredictInterceptExact(self:GetPos(), self.Speed, self.Target:GetPos(), self.Target:GetVelocity())
    local dir = (interceptPoint - self:GetPos()):GetNormalized()

    -- Apply velocity toward intercept
    phys:SetVelocity(dir * self.Speed)
    self:SetAngles(dir:Angle())

    -- Detonation
    if self:GetPos():Distance(interceptPoint) < IronDomeConsts.MissileExplosionDist then
        local explosion = ents.Create("env_explosion")
        explosion:SetPos(self:GetPos())
        explosion:SetKeyValue("iMagnitude", tostring(IronDomeConsts.MissileExplosionMag))
        explosion:Spawn()
        explosion:Fire("Explode", 0, 0)

        if self.Target:IsPlayer() then
            self.Target:Kill()
        else
            self.Target:Remove()
        end

        self:Remove()
        return
    end

    self:NextThink(CurTime())
    return true
end
