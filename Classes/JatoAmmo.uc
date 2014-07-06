//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoAmmo extends Ammunition;

DefaultProperties
{
    ItemName                    = "Plasma Ammo"
    PickupClass                 = class'JatoAmmoPickup'

    IconMaterial                = Material'HudContent.Generic.HUD'
    IconCoords                  = (X1=460,Y1=343,X2=488,Y2=392)

    MaxAmmo                     = 50
    InitialAmount               = 10

    bRecommendSplashDamage      = False
    bTossed                     = True
    bTrySplash                  = False
    bLeadTarget                 = True
    bInstantHit                 = False
    bSplashDamage               = False
    bTryHeadShot                = False

    MaxRange                    = 16384

    ProjectileClass             = class'JatoProjectile'
    MyDamageType                = class'DamTypeJato'
    WarnTargetPct               = 0.3
    RefireRate                  = 0.4

    FireSound                   = None
    IconFlashMaterial           = None
}