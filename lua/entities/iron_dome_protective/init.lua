AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("core/intercept_predict.lua")

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
        phys:EnableMotion(false) -- stays in place
    end

    -- Siren
    self.SirenSound = CreateSound(self, "iron_dome/iron_dome_alarm.wav")
    self.SirenPlaying = false
    self.SirenVolume = 1
    self.SirenHoldTime = 10      -- seconds to keep siren playing after last threat
    self.SirenStopTime = 0       -- next time to stop siren

    -- Health & Damage
    self.MaxHealth = 1000
    self:SetHealth(self.MaxHealth)

    -- Cooldowns & missiles
    self.ActiveMissiles = {}
    self.ActiveTargets = {} -- keys are target entities, values are true while being engaged
    self.NextFireGlobal = CurTime()
    self.MissilesLeft = 20
    self.Reloading = false
    self.NextScan = CurTime()
end

-- Only take blast damage
function ENT:OnTakeDamage(dmginfo)
    if not dmginfo:IsDamageType(DMG_BLAST) then return end
    local damage = dmginfo:GetDamage()
    local newHealth = self:Health() - damage
    self:SetHealth(newHealth)

    if newHealth <= 0 then
        self:Explode()
    end
end

function ENT:Explode()
    if not IsValid(self) or self.Exploded then return end
    self.Exploded = true -- prevent double explosion

    -- Create explosion safely
    local explosion = ents.Create("env_explosion")
    if not IsValid(explosion) then return end

    explosion:SetPos(self:GetPos())
    explosion:SetKeyValue("iMagnitude", "500")      -- explosion damage
    explosion:SetKeyValue("iRadiusOverride", "300") -- optional blast radius
    explosion:SetOwner(self:GetOwner() or self)
    explosion:Spawn()
    explosion:Fire("Explode", 0, 0)

    -- Make sure the dome itself won't be affected by its own explosion
    explosion:SetSaveValue("iMagnitude", 0) -- optional safety

    self:Remove() -- finally remove the dome
end


function ENT:Think()
    if CurTime() < self.NextScan then return end
    self.NextScan = CurTime() + 0.25
    self.ActiveMissiles = self.ActiveMissiles or {}
    self.ActiveTargets  = self.ActiveTargets  or {}

    if self.Reloading then return end
    if not self.MissilesLeft then self.MissilesLeft = 20 end
    if self.MissilesLeft <= 0 then
        self.Reloading = true
        local dome = self
        timer.Simple(10, function()
            if IsValid(dome) then
                dome.MissilesLeft = 20
                dome.Reloading = false
                -- optional: play reload sound here
            end
        end)
        return
    end

    local detectionRadius = 5000
    local pos = self:GetPos()
    local hasTarget = false

    for _, ent in ipairs(ents.FindInSphere(pos, detectionRadius)) do
        if not IsValid(ent) or ent == self then continue end
        local class = ent:GetClass()
        if not (string.find(class,"missile") or string.find(class,"bomb") or string.find(class,"rocket")) then continue end
        if ent:IsPlayerHolding() then continue end

        -- Ignore projectiles from dome owner
        if ent:GetOwner() == self:GetOwner() then
            print("[IronDome] Ignoring owner projectile:", ent)
            continue
        end

        hasTarget = true
        local key = ent:EntIndex()

        -- Skip if another dome already claimed this target
        if IronDome_GlobalTargets[ent] and IronDome_GlobalTargets[ent] ~= self then
            print("[IronDome] Skipping target (claimed by another dome):", ent, "Index:", key)
            continue
        end

        -- Fire only if this dome hasn’t engaged it yet
        if not self.ActiveTargets[key] then
            if CurTime() >= self.NextFireGlobal then
                print("[IronDome] Launching interceptor at target:", ent, "Index:", key)
                self.ActiveTargets[key] = true
                IronDome_GlobalTargets[ent] = self -- mark globally claimed
                self:LaunchInterceptor(ent)
                self.NextFireGlobal = CurTime() + 0.5
                break -- only one missile per scan
            end
        else
            print("[IronDome] Target already engaged by me:", ent, "Index:", key)
        end
    end

    -- Siren logic with 10-second grace period
    if hasTarget then
        if not self.SirenPlaying then
            if self.SirenSound then
                self.SirenSound:Play()
                self.SirenSound:ChangeVolume(self.SirenVolume, 0)
                self.SirenSound:SetSoundLevel(1060)
            end
            self.SirenPlaying = true
        end
        self.SirenStopTime = CurTime() + self.SirenHoldTime
    elseif self.SirenPlaying then
        if not self.SirenStopTime then
            self.SirenStopTime = CurTime() + self.SirenHoldTime
        elseif CurTime() >= self.SirenStopTime then
            if self.SirenSound then
                self.SirenSound:Stop()
            end
            self.SirenPlaying = false
            self.SirenStopTime = nil
        end
    end
end



function ENT:LaunchInterceptor(target)
    if not IsValid(target) then return end

    local missile = ents.Create("iron_dome_missile")
    if not IsValid(missile) then return end

    missile:SetPos(self:GetPos() + Vector(0,0,100))
    missile:SetOwner(self)
    missile:Spawn()
    missile:SetTarget(target)

    local dome = self
    local key = target:EntIndex()


    missile:CallOnRemove("ClearActiveMissile", function()
        if IsValid(dome) then
            dome.ActiveTargets[key] = nil
        end
        if IronDome_GlobalTargets[target] == dome then
            IronDome_GlobalTargets[target] = nil
        end
    end)

    self.ActiveMissiles[key] = missile
end
