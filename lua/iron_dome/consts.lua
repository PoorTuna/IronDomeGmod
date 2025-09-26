-- lua/iron_dome/consts.lua
IronDomeConsts = IronDomeConsts or {}

-- Dome / Integrity
IronDomeConsts.MaxHealth         = 1000
IronDomeConsts.SirenVolume       = 1
IronDomeConsts.SirenHoldTime     = 10       -- seconds
IronDomeConsts.ReloadTime        = 10       -- seconds
IronDomeConsts.MissilesPerReload = 20
IronDomeConsts.ScanInterval      = 0.25     -- seconds

-- Missile / Interceptor
IronDomeConsts.MissileSpeed           = 3500
IronDomeConsts.MissileSpawnHeight     = 100
IronDomeConsts.DetectionRadius        = 8000
IronDomeConsts.MissileExplosionMag    = 120
IronDomeConsts.MissileExplosionDist   = 100
IronDomeConsts.MissileTrailStart      = 6
IronDomeConsts.MissileTrailEnd        = 16
IronDomeConsts.MissileTrailTexture    = "trails/smoke.vmt"

-- Dome Destruction / Blast
IronDomeConsts.ExplosionMagnitude     = 500
IronDomeConsts.ExplosionRadius        = 300

-- Sound / Audio
IronDomeConsts.SirenSoundPath         = "iron_dome/iron_dome_alarm.wav"
IronDomeConsts.LeverSoundPath         = "buttons/lever4.wav"
IronDomeConsts.SirenSoundLevel        = 1060
