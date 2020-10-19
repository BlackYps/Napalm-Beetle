
#------------------------------------------------------------------------
#  TERRAN HEAVY NAPALM CARPET BOMB
#------------------------------------------------------------------------
local TNapalmHvyCarpetBombProjectile = Class(SinglePolyTrailProjectile) {
    FxTrails = {},

    FxImpactTrajectoryAligned = false,

    # Hit Effects
    FxImpactUnit = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactProp = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactLand = EffectTemplate.TNapalmHvyCarpetBombHitLand01,
    FxImpactWater = EffectTemplate.TNapalmHvyCarpetBombHitWater01,
    FxImpactUnderWater = {},
    PolyTrail = '/effects/emitters/default_polytrail_01_emit.bp',
}
