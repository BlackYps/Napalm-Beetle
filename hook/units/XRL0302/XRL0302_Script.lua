----------------------------------------------------------------
-- File     :  /data/units/XRL0302/XRL0302_script.lua
-- Author(s):  Jessica St. Croix, Gordon Duclos
-- Summary  :  Cybran Mobile Bomb Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon


local NapalmDeathWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = {'/effects/emitters/antiair_muzzle_fire_02_emit.bp',},
    
    CreateProjectileForWeapon = function(self, bone)
        local projectile = self:CreateProjectile(bone)
        local damageTable = self:GetDamageTable()
        local blueprint = self:GetBlueprint()
        local data = {
            Instigator = self.unit,
            Damage = blueprint.DoTDamage,
            Duration = blueprint.DoTDuration,
            Frequency = blueprint.DoTFrequency,
            Radius = blueprint.DamageRadius,
            Type = 'Normal',
            DamageFriendly = blueprint.DamageFriendly,
        }
        if projectile and not projectile:BeenDestroyed() then
            projectile:PassData(data)
            projectile:PassDamageData(damageTable)
        end
        return projectile
    end,
    
    Fire = function(self)
        ChangeState(self, self.RackSalvoFiringState)
    end,
}

XRL0302 = Class(CWalkingLandUnit) {

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'XRL0302',
                },
                Scale = 3.0,
                Type = 'Cloak01',
            },
        },
    },

    Weapons = {
        Suicide = Class(CMobileKamikazeBombWeapon) {},
        DeathWeapon = Class(NapalmDeathWeapon) {},
    },

    AmbientExhaustBones = {
        'XRL0302',
    },

    AmbientLandExhaustEffects = {
        '/effects/emitters/cannon_muzzle_smoke_12_emit.bp',
    },

    OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)

        self.EffectsBag = {}
        self.AmbientExhaustEffectsBag = {}
        self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.EffectsBag)
        self.PeriodicFXThread = self:ForkThread(self.EmitPeriodicEffects)
    end,

    -- Allow the trigger button to blow the weapon, resulting in OnKilled instigator 'nil'
    OnProductionPaused = function(self)
        self:GetWeaponByLabel('DeathWeapon'):Fire()
        self:GetWeaponByLabel('Suicide'):FireWeapon()
    end,
    
    EmitPeriodicEffects = function(self)
        while not self.Dead do
            local army = self:GetArmy()

            for kE, vE in self.AmbientLandExhaustEffects do
                for kB, vB in self.AmbientExhaustBones do
                    table.insert(self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE))
                end
            end

            WaitSeconds(3)
            EffectUtil.CleanupEffectBag(self, 'AmbientExhaustEffectsBag')

        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
        if instigator then
            self:GetWeaponByLabel('Suicide'):FireWeapon()
        end
    end,
    
    DoDeathWeapon = function(self)
        if self:IsBeingBuilt() then return end

        if self.EffectsBag then
            EffectUtil.CleanupEffectBag(self, 'EffectsBag')
            self.EffectsBag = nil
        end
        if self.AmbientExhaustEffectsBag then
            EffectUtil.CleanupEffectBag(self, 'AmbientExhaustEffectsBag')
            self.AmbientExhaustEffectsBag = nil
        end
        self.PeriodicFXThread:Destroy()
        self.PeriodicFXThread = nil
        CWalkingLandUnit.DoDeathWeapon(self) -- Handle the normal DeathWeapon procedures

        -- Now handle our special buff
        local bp
        for k, v in self:GetBlueprint().Buffs do
            if v.Add.OnDeath then
                bp = v
            end
        end

        -- If we could find a blueprint with v.Add.OnDeath, then add the buff
        if bp ~= nil then
            self:AddBuff(bp)
        end
    end,
    
    OnDestroy = function(self)
        CWalkingLandUnit.OnDestroy(self)
    end,
}

TypeClass = XRL0302
