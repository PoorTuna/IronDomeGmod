AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("iron_dome/main.lua")
include("iron_dome/consts.lua")

IronDome_GlobalTargets = IronDome_GlobalTargets or {}

function ENT:Initialize()
    self:SetModel("models/props/iron_dome.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableGravity(true)
        phys:EnableMotion(false)
    end

    -- Siren
    self.SirenSound = CreateSound(self, IronDomeConsts.SirenSoundPath)
    self.SirenPlaying = false
    self.SirenVolume = IronDomeConsts.SirenVolume
    self.SirenHoldTime = IronDomeConsts.SirenHoldTime
    self.SirenStopTime = 0

    -- Health
    self.MaxHealth = IronDomeConsts.MaxHealth
    self:SetHealth(self.MaxHealth)

    -- Missile state
    self.ActiveMissiles = {}
    self.ActiveTargets = {}
    self.NextFireGlobal = CurTime()
    self.MissilesLeft = IronDomeConsts.MissilesPerReload
    self.Reloading = false
    self.NextScan = CurTime()
end

function ENT:OnTakeDamage(dmginfo)
    TakeBlastDamage(self, dmginfo)
end

function ENT:Think()
    if CurTime() < self.NextScan then return end
    self.NextScan = CurTime() + IronDomeConsts.ScanInterval

    self.ActiveMissiles = self.ActiveMissiles or {}
    self.ActiveTargets  = self.ActiveTargets or {}

    if not HandleReload(self) then return end

    local pos = self:GetPos()
    local hasTarget = false
    local detectionRadius = IronDomeConsts.DetectionRadius

    for _, ent in ipairs(ents.FindInSphere(pos, detectionRadius)) do
        if not IsValidTarget(self, ent) then continue end

        -- Protective dome: ignore owner projectiles
        if ent:GetOwner() == self:GetOwner() then continue end

        hasTarget = true
        ClaimTarget(self, ent)
        CreateInterceptor(self, ent)
        self.MissilesLeft = (self.MissilesLeft or 20) - 1
        break
    end

    UpdateSiren(self, hasTarget)
end
