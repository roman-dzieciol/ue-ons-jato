//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoFire extends ProjectileFire;

var JatoGun Gun;


function PostBeginPlay()
{
    Super.PostBeginPlay();

    Gun = JatoGun(Weapon);
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    GotoState('');
    xLog("SpawnProjectile");
    return None;
}

event ModeHoldFire()
{
    GotoState('Aiming');
}

state Aiming
{
    function BeginState()
    {
    }

    function EndState()
    {
        Gun.Marker.bHidden = True;
        Gun.Target = None;
        Gun.Preview.bHidden = True;
    }

    function ModeTick( float DT )
    {
        local vector HL,HN,TE,TS,X,Y,Z,COM,EX;
        local Actor A;

        Gun.Preview.bHidden = True;
        Gun.Marker.bHidden = true;
        Gun.Target = None;

        Weapon.GetViewAxes(X,Y,Z);

        EX = vect(8,8,8);
        TS = GetFireStart(X,Y,Z);
        TE = TS + X * 384;

        //Weapon.DrawDebugLine(TS-vect(0,0,32),TE-vect(0,0,32),255,0,0);
        A = Weapon.Trace(HL,HN,TE,TS,true,EX);

        if( A == None )
        {
            HL = TE;
        }
            //Gun.Marker.SetLocation(HL);

        if( A != None && A.Physics == PHYS_Karma )
        {
            A.KGetCOMPosition(COM);
            Gun.Target = A;
            Gun.Marker.SetRotation(A.Rotation);
            Gun.Marker.SetLocation(COM);
            Gun.Marker.bHidden = false;
            Gun.Marker.AdjustDrawScale(A.CollisionRadius,A.CollisionHeight);
            Gun.Preview.bHidden = False;

            Gun.AimPos = HL;
            Gun.AimRot = rotator(HL-TS);
            Gun.TargetCOM = COM;
            //xLog(A);
        }
            //xLog(A @HL);
    }

    event ModeDoFire()
    {
        xLog("ModeDoFire");
        Super.ModeDoFire();
        GotoState('');
    }
    function Projectile SpawnProjectile( Vector Start, Rotator Dir )
    {
        local JatoProjectile G;

        xLog("SpawnProjectile");

        if( Gun.Target != None )
        {
            Start = Gun.SpawnPos;
            Dir = Gun.SpawnRot;
        }

        G = JatoProjectile(Super.SpawnProjectile(Start, Dir));
        if (G != None && Gun != None)
        {
            G.SetOwner(Gun);
            Gun.Projectiles[Gun.Projectiles.length] = G;
            if( Gun.Target != None )
            {
                G.Stick(Gun.Target);
            }
        }


        return G;
    }

}



// ============================================================================
// Debug
// ============================================================================

simulated final function xLog ( coerce string s )
{
    Log
    (   "[" $Left("000",3-Len(Level.Millisecond)) $ Level.Millisecond $"]"
    @   "[" $GetStateName()$ "]"
    @   s
    ,   name );
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
    bFireOnRelease              = True
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
    AmmoPerFire                 = 1

    ShakeOffsetMag              = (X=0.0,Y=0.0,Z=-2.0)
    ShakeOffsetRate             = (X=0.0,Y=0.0,Z=1000.0)
    ShakeOffsetTime             = 1.8
    ShakeRotMag                 = (X=70.0,Y=0.0,Z=0.0)
    ShakeRotRate                = (X=1000.0,Y=0.0,Z=0.0)
    ShakeRotTime                = 1.8

    ProjectileClass             = class'JatoProjectile'
    ProjSpawnOffset             = (X=0,Y=0,Z=-8)

    BotRefireRate               = 0.8
    WarnTargetPct               = 0.1

    FlashEmitterClass           = class'XEffects.BioMuzFlash1st'
    SmokeEmitterClass           = None

    AimError                    = 1536
    Spread                      = SS_Random

    TransientSoundVolume        = 1.0
    TransientSoundRadius        = 512
}


