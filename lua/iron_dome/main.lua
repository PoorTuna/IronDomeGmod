-- lua/iron_dome/main.lua
-- Central import file for Iron Dome core systems

-- Integrity systems (dome self-maintenance)
include("iron_dome/core/health.lua")
include("iron_dome/core/reload.lua")
include("iron_dome/core/siren.lua")

-- Missile systems
include("iron_dome/missile/intercept_predict.lua")
include("iron_dome/missile/missile_factory.lua")

-- Targeting systems
include("iron_dome/target/target_claim.lua")
include("iron_dome/target/target_filter.lua")
