-- Lua/iron_dome/convars.lua

-- Dome / Integrity
CreateConVar("iron_dome_max_health", "1000", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Max health of the dome")
CreateConVar("iron_dome_siren_volume", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Siren volume")
CreateConVar("iron_dome_reload_time", "10", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Seconds to reload missiles")
CreateConVar("iron_dome_missiles_per_reload", "20", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of missiles per reload")

-- Missile / Interceptor
CreateConVar("iron_dome_missile_speed", "3500", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Speed of the interceptor missile")
CreateConVar("iron_dome_detection_radius", "8000", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Detection radius of the dome")
