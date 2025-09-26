-- lua/iron_dome/consts.lua
include("iron_dome/convars.lua")

IronDomeConsts = IronDomeConsts or {}

-- Dome / Integrity
IronDomeConsts.MaxHealth         = GetConVar("iron_dome_max_health"):GetInt()
IronDomeConsts.SirenVolume       = GetConVar("iron_dome_siren_volume"):GetFloat()
IronDomeConsts.SirenHoldTime     = 10       -- still fixed, or make a ConVar if you want
IronDomeConsts.ReloadTime        = GetConVar("iron_dome_reload_time"):GetFloat()
IronDomeConsts.MissilesPerReload = GetConVar("iron_dome_missiles_per_reload"):GetInt()
IronDomeConsts.ScanInterval      = 0.25     -- optional ConVar

-- Missile / Interceptor
IronDomeConsts.MissileSpeed      = GetConVar("iron_dome_missile_speed"):GetFloat()
IronDomeConsts.MissileSpawnHeight= 100      -- optional ConVar
IronDomeConsts.DetectionRadius   = GetConVar("iron_dome_detection_radius"):GetFloat()
IronDomeConsts.MissileExplosionMag = 120
IronDomeConsts.MissileExplosionDist= 100
IronDomeConsts.MissileTrailStart   = 6
IronDomeConsts.MissileTrailEnd     = 16
IronDomeConsts.MissileTrailTexture = "trails/smoke.vmt"

-- Dome Destruction / Blast
IronDomeConsts.ExplosionMagnitude = 500
IronDomeConsts.ExplosionRadius    = 300

-- Sound / Audio
IronDomeConsts.SirenSoundPath     = "iron_dome/iron_dome_alarm.wav"
IronDomeConsts.LeverSoundPath     = "buttons/lever4.wav"
IronDomeConsts.SirenSoundLevel    = 1060
