//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class DamTypeJato extends WeaponDamageType;

DefaultProperties
{
    // DamageType
    DeathString                 = "%k killed %o."
    MaleSuicide                 = "To The Moon %o! To The Moon!"
    FemaleSuicide               = "To The Moon %o! To The Moon!"

    ViewFlash                   = 0.3
    ViewFog                     = (X=900.00000,Y=0.000000,Z=0.00000)
    DamageEffect                = None
    DamageWeaponName            = "ACME Jato Kit"
    bArmorStops                 = True
    bInstantHit                 = False
    bFastInstantHit             = False
    bAlwaysGibs                 = False
    bLocationalHit              = False
    bAlwaysSevers               = False
    bSpecial                    = False
    bDetonatesGoop              = True
    bSkeletize                  = False
    bCauseConvulsions           = False
    bSuperWeapon                = False
    bCausesBlood                = True
    bKUseOwnDeathVel            = False
    bKUseTearOffMomentum        = False
    bDelayedDamage              = True
    bNeverSevers                = False
    bThrowRagdoll               = True
    bRagdollBullet              = False
    bLeaveBodyEffect            = False
    bExtraMomentumZ             = True
    bFlaming                    = True
    bRubbery                    = False
    bCausedByWorld              = False
    bDirectDamage               = True
    bBulletHit                  = False
    bVehicleHit                 = False

    GibModifier                 = 1.1

    PawnDamageEffect            = None
    PawnDamageEmitter           = None
    PawnDamageSounds            = None

    LowGoreDamageEffect         = None
    LowGoreDamageEmitter        = None
    LowGoreDamageSounds         = None

    LowDetailEffect             = None
    LowDetailEmitter            = None

    FlashScale                  = 0.3
    FlashFog                    = (X=900.00000,Y=0.000000,Z=0.00000)

    DamageDesc                  = 1
    DamageThreshold             = 1
    DamageKick                  = (X=0.0,Y=0.0,Z=0.0)
    DamageOverlayMaterial       = None
    DeathOverlayMaterial        = None
    DamageOverlayTime           = 0
    DeathOverlayTime            = 0

    GibPerterbation             = 0.1

    KDamageImpulse              = 150000
    KDeathVel                   = 2000
    KDeathUpKick                = 1000

    VehicleDamageScaling        = 1
    VehicleMomentumScaling      = 1

    // WeaponDamageType
    WeaponClass                 = class'JatoGun'
}