
local TNapalmHvyCarpetBombProjectile = import('/lua/terranprojectiles.lua').TNapalmHvyCarpetBombProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

FireBeetleBomb = Class(TNapalmHvyCarpetBombProjectile) {

    OnImpact = function(self, targetType, targetEntity)
        if targetType ~= 'Shield' and targetType ~= 'Water' and targetType ~= 'Air' and targetType ~= 'UnitAir' and targetType ~= 'Projectile' then
            local rotation = RandomFloat(0,2*math.pi)
            local radius = self.DamageData.DamageRadius
            local size = radius + RandomFloat(0.75,2.0)
            local pos = self:GetPosition()
            local army = self.Army

            DamageRing(self, pos, 0.1, 5/4 * radius, 10, 'Fire', false, false)
            DamageArea(self, pos, radius, 1, 'Force', true)
            DamageArea(self, pos, radius, 1, 'Force', true)
            CreateDecal(pos, rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 50, army)
        end
        TNapalmHvyCarpetBombProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

TypeClass = FireBeetleBomb
