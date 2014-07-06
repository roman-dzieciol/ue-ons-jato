//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoFireAlt extends WeaponFire;

var JatoGun Gun;

function PostBeginPlay()
{
    Super.PostBeginPlay();

    Gun = JatoGun(Weapon);
}

function DoFireEffect()
{
    local int x;

    for (x = 0; x < Gun.Projectiles.Length; x++)
        if (Gun.Projectiles[x] != None)
        {
            Gun.Projectiles[x].Gotostate('Thrust');
        }
}

DefaultProperties
{
    bSplashDamage               = False
    bSplashJump                 = False
    bRecommendSplashDamage      = False
    bLeadTarget                 = True
    bInstantHit                 = False

    bPawnRapidFireAnim          = False
    bReflective                 = False
    bFireOnRelease              = False
    bWaitForRelease             = False
    bModeExclusive              = False

    bAttachSmokeEmitter         = False
    bAttachFlashEmitter         = False

    PreFireTime                 = 0
    MaxHoldTime                 = 0

    PreFireAnim                 = "PreFire"
    FireAnim                    = "Fire"
    FireLoopAnim                = "FireLoop"
    FireEndAnim                 = "FireEnd"
    ReloadAnim                  = "Reload"

    PreFireAnimRate             = 1.0
    FireAnimRate                = 1.0
    FireLoopAnimRate            = 1.0
    FireEndAnimRate             = 1.0
    ReloadAnimRate              = 1.0
    TweenTime                   = 0.1

    FireSound                   = Sound'WeaponSounds.BioRifle.BioRifleFire'
    ReloadSound                 = None
    NoAmmoSound                 = None

    FireForce                   = "BioRifleFire"
    ReloadForce                 = ""
    NoAmmoForce                 = ""

    FireRate                    = 0.33

    AmmoClass                   = class'JatoAmmo'
    AmmoPerFire                 = 0

    ShakeOffsetMag              = (X=0.0,Y=0.0,Z=-2.0)
    ShakeOffsetRate             = (X=0.0,Y=0.0,Z=1000.0)
    ShakeOffsetTime             = 1.8
    ShakeRotMag                 = (X=70.0,Y=0.0,Z=0.0)
    ShakeRotRate                = (X=1000.0,Y=0.0,Z=0.0)
    ShakeRotTime                = 1.8

    ProjectileClass             = class'JatoProjectile'

    BotRefireRate               = 0.8
    WarnTargetPct               = 0.1

    FlashEmitterClass           = class'XEffects.BioMuzFlash1st'
    SmokeEmitterClass           = None

    TransientSoundVolume        = 1.0
    TransientSoundRadius        = 512
}