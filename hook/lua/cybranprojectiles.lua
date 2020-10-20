
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local EffectTemplate = import('/mods/napalm beetle/hook/lua/EffectTemplates.lua')

#------------------------------------------------------------------------
#  CYBRAN NAPALM BOMB
#------------------------------------------------------------------------
CNapalmBombProjectile = Class(SinglePolyTrailProjectile) {
    FxTrails = {},

    FxImpactTrajectoryAligned = false,

    # Hit Effects
    FxImpactUnit = EffectTemplate.CNapalmBombHitLand01,
    FxImpactProp = EffectTemplate.CNapalmBombHitLand01,
    FxImpactLand = EffectTemplate.CNapalmBombHitLand01,
    FxImpactWater = EffectTemplate.CNapalmBombHitWater01,
    FxImpactUnderWater = {},
    PolyTrail = '/effects/emitters/default_polytrail_03_emit.bp',
}
