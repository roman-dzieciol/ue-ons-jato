//=============================================================================
// Jato Projectile
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoProjectile extends Projectile;

var class<Emitter> ThrustEmitterClass;
var Emitter ThrustEmitter;
var Actor StickActor;
var Actor InitializedActor;

// ============================================================================
// Lifespan
// ============================================================================
simulated function PostBeginPlay()
{
    //xLog( "PostBeginPlay" );

    AmbientSound = None;
    Acceleration = Speed * Vector(Rotation);
    Super.PostBeginPlay();

}

simulated event Destroyed()
{
    //xLog( "Destroyed" @Base );

    if( ThrustEmitter != None )
    {
        ThrustEmitter.Destroy();
    }

    if( StickActor != None && !StickActor.bDeleteMe )
    {
        ResetActor(StickActor);
    }

    Super.Destroyed();
}


// ============================================================================
// World collision
// ============================================================================

simulated function Landed( vector HitNormal )
{
    Error( "Landed" );
}

simulated function HitWall( vector HitNormal, Actor Other )
{
    //xLog( "HitWall" @Other.name );


    Stick(Other);

}


// ============================================================================
// Actor collision
// ============================================================================

simulated singular function Touch( Actor Other )
{
    local vector HitLocation,HitNormal;

    //xLog( "Touch" @Other.name );

    if( Other == None || !(Other.bProjTarget || Other.bBlockActors) || JatoProjectile(Other) != None )
        return;

    LastTouched = Other;

    if( Velocity == vect(0,0,0)
    ||  Other.IsA('Mover')
    ||  Other.TraceThisActor(HitLocation, HitNormal, Location, Location - 2*Velocity, GetCollisionExtent()) )
    {
        HitLocation = Location;
    }

    ProcessTouch(Other, HitLocation);
    LastTouched = None;

    if( Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != None )
        ClientSideTouch(Other, HitLocation);
}

simulated function ProcessTouch( Actor Other, vector HitLocation )
{
    //xLog( "ProcessTouch" @Other );

    if( Other == Instigator )
        return;

    if( Pawn(Other) != None )
    {
        Stick(Other);
    }
}

simulated function Stick( Actor Other )
{
    //local vector COMpos;
    //xLog( "Stick" @Other );


    //Other.KGetCOMPosition(COMpos);
    //xLog( VSize(COMpos-Location) @ Other.KGetMass() );

    bCollideWorld = False;
    //SetCollision(false,false);
    SetPhysics(PHYS_None);
    Velocity = vect(0,0,0);
    Acceleration = vect(0,0,0);
    SetCollision(false,false);

    SetBase(Other);
    StickActor = Other;

    if(Pawn(Other)!=None)
        LifeSpan = 0;

    GotoState('Sticked');
}



state Sticked
{


    simulated function HitWall( vector HitNormal, Actor Other )
    {
    }

    simulated singular function Touch( Actor Other )
    {
    }

    simulated singular event BaseChange()
    {
        if( Base == None )
        {
            Destroy();
        }
    }
}

state Thrust extends Sticked
{
    simulated event BeginState()
    {
        xLog( "BeginState" );

        AmbientSound = default.AmbientSound;
        ThrustEmitter = spawn(THrustEmitterClass,self,,,rotator(-vector(Rotation)));
        ThrustEmitter.SetBase(self);
        LifeSpan = 25;
        InitActor(StickActor);
    }

    simulated function Tick( float DeltaTime )
    {
        local vector HitMomentum, HitOffset,TS,TO,COMpos;
        local rotator FR;

        if( Base != None )
        {
            if( Base.Physics == PHYS_Walking
            ||  Base.Physics == PHYS_Falling
            ||  Base.Physics == PHYS_Flying
            ||  Base.Physics == PHYS_Swimming )
            {
                HitMomentum = vector(Rotation) /*Normal(COMpos-Location)*/ * MomentumTransfer * 0.2;
                Base.SetPhysics(PHYS_Falling);
                Base.Velocity += HitMomentum * DeltaTime;
                //FR = 8192 * DeltaTime * RotRand(true);
                //SetRotation(Rotation + FR);
            }

            if( Base.Physics == PHYS_Karma )
            {
                Base.KGetCOMPosition(COMpos);
                HitMomentum = vector(Rotation) /*Normal(COMpos-Location)*/ * MomentumTransfer * 2;
                HitOffset = Location;


                TS = COMpos;

                TO = Normal(HitOffset)*256;
                //DrawDebugLine(TS,TS+TO,0,255,0);
                //DrawDebugLine(TS,TS-TO,255,0,0);

                TS = Location;
                TO = Normal(HitMomentum)*256;
                //DrawDebugLine(TS+vect(4,4,0),TS+vect(4,4,0)-TO,255,128,0);
                //DrawDebugLine(TS+vect(4,4,0),TS+vect(4,4,0)+TO,0,128,255);

                Base.KAddImpulse( HitMomentum * DeltaTime /** Base.KGetMass()*/, HitOffset  );



            }
        }
        else
        {
            Acceleration = vector(Rotation) * Speed * 10;
        }
    }

Begin:
    Sleep(FRand()*0.5);
}


simulated function InitActor( Actor A )
{
    local int i;


    for( i=0; i!=A.Attached.Length; ++i )
    {
        //xLog( "InitActor[]" @A.Attached[i] );
        if( JatoProjectile(A.Attached[i]) != None
        &&  JatoProjectile(A.Attached[i]) != Self
        &&  JatoProjectile(A.Attached[i]).InitializedActor != None
        && !JatoProjectile(A.Attached[i]).bDeleteMe )
            return;
    }


    xLog( "InitActor" @A );
    InitializedActor = A;

    //A.bIgnoreTerminalVelocity = True;

    if( A.Physics == PHYS_Karma )
    {
        A.KParams.default.KFriction = A.KParams.KFriction;

        A.KSetFriction( A.KParams.default.KFriction * 0.1 );
        A.KSetImpactThreshold(1);

        if( Pawn(A) != None )
        {
        }

        if( ONSWheeledCraft(A) != None )
        {

        }

        if( KarmaParams(A.KParams) != None )
        {
            KarmaParams(A.KParams).default.bKStayUpright = KarmaParams(A.KParams).bKStayUpright;
            KarmaParams(A.KParams).default.bKAllowRotate = KarmaParams(A.KParams).bKAllowRotate;
            A.KSetStayUpright(false,true);
        }


        if( ONSVehicle(A) != None )
        {
            ONSVehicle(A).default.bEjectPassengersWhenFlipped = ONSVehicle(A).bEjectPassengersWhenFlipped;
            ONSVehicle(A).bEjectPassengersWhenFlipped = False;
            ONSVehicle(A).DisintegrationHealth = -1000;
            ONSVehicle(A).ImpactDamageTicks = 50;

            ONSVehicle(A).ImpactDamageMult = FMax( ONSVehicle(A).default.ImpactDamageMult, 0.0000005
            * ONSVehicle(A).default.Health
            * (2000/ONSVehicle(A).default.GroundSpeed) );
            log(ONSVehicle(A).ImpactDamageMult);
        }

        if( SVehicle(A) != None )
        {
        }

        if( Vehicle(A) != None )
        {
            Vehicle(A).default.bCanFlip = Vehicle(A).bCanFlip;
            Vehicle(A).bCanFlip = true;
        }

    }
}

simulated function ResetActor( Actor A )
{
    local int i;


    for( i=0; i!=A.Attached.Length; ++i )
    {
        if( JatoProjectile(A.Attached[i]) != None
        &&  JatoProjectile(A.Attached[i]) != Self
        && !JatoProjectile(A.Attached[i]).bDeleteMe )
            return;
    }


    xLog( "ResetActor" @A );

    //A.bIgnoreTerminalVelocity = A.default.bIgnoreTerminalVelocity;

    if( A.Physics == PHYS_Karma )
    {
        A.KSetFriction( A.KParams.default.KFriction );

        if( Pawn(A) != None )
        {
        }

        if( ONSWheeledCraft(A) != None )
        {

        }

        if( KarmaParams(A.KParams) != None )
        {
            A.KSetStayUpright(KarmaParams(A.KParams).default.bKStayUpright,KarmaParams(A.KParams).default.bKAllowRotate);
        }


        if( ONSVehicle(A) != None )
        {
            ONSVehicle(A).bEjectPassengersWhenFlipped = ONSVehicle(A).default.bEjectPassengersWhenFlipped;
            ONSVehicle(A).DisintegrationHealth = ONSVehicle(A).default.DisintegrationHealth;
            ONSVehicle(A).ImpactDamageTicks = ONSVehicle(A).default.ImpactDamageTicks;
        }

        if( SVehicle(A) != None )
        {
        }

        if( Vehicle(A) != None )
        {
            //Vehicle(A).bCanFlip = Vehicle(A).default.bCanFlip;
        }

    }
}

// ============================================================================
// Effects
// ============================================================================

simulated function Explode( vector HitLocation, vector HitNormal )
{
    //Error( "Explode" );
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

// ============================================================================
// DefaultProperties
// ============================================================================
DefaultProperties
{
    ThrustEmitterClass          = Class'Onslaught.ONSAttackCraftExhaust'

    // Actor
    CollisionRadius             = 8
    CollisionHeight             = 8
    Physics                     = PHYS_Falling
    LifeSpan                    = 60
    bIgnoreTerminalVelocity     = True
    bOrientToVelocity           = False

    bProjTarget                 = True
    bCollideActors              = True
    bCollideWorld               = True
    bBlockActors                = False
    bBounce                     = True // No Landed() please
    bHardAttach                 = True
    bUseCollisionStaticMesh     = True
    bUseCylinderCollision       = False

    bNetTemporary               = False
    RemoteRole                  = ROLE_SimulatedProxy

    DrawType                    = DT_StaticMesh
    StaticMesh                  = StaticMesh'VMWeaponsSM.AVRiLprojectileSM'
    DrawScale                   = 0.2
    AmbientGlow                 = 100

    SoundRadius                 = 128
    SoundVolume                 = 255
    AmbientSound                = Sound'WeaponSounds.RocketLauncherProjectile'
    bFullVolume                 = False

    // Projectile
    Speed                       = 1200
    MaxSpeed                    = 1200
    TossZ                       = 0

    bSwitchToZeroCollision      = False
    bNoFX                       = False
    bReadyToSplash              = False
    bSpecialCalcView            = False

    Damage                      = 100
    DamageRadius                = 512
    MomentumTransfer            = 150000
    MyDamageType                = Class'DamTypeJato'

    ImpactSound                 = Sound'WeaponSounds.P1GrenFloor1'
    SpawnSound                  = None

    ExplosionDecal              = class'Onslaught.ONSRocketScorch'
    ExploWallOut                = 5

    MaxEffectDistance           = 8000
    bScriptPostRender           = False
}