//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoGun extends Weapon;

var array<JatoProjectile> Projectiles;

var JatoMarker Marker;
var class<JatoMarker> MarkerClass;
var Actor Target;
var vector TargetCOM;
var float TargetDot;
var float TargetAng;
var color TextColor;

var vector AimPos;
var rotator AimRot;
var float AimSin;
var float AimCos;
var float AimTau;

var vector SpawnPos;
var rotator SpawnRot;

var JatoPreview Preview;
var class<JatoPreview> PreviewClass;

var vector Torque;
var vector TorqueOld;
var vector TorqueNew;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    Marker = Spawn(MarkerClass,self);
    Preview = Spawn(PreviewClass,self);
}

simulated function Destroyed()
{
    Super.Destroyed();
    if( Marker != None )
        Marker.Destroy();
    if( Preview != None )
        Preview.Destroy();
}


function float GetAIRating()
{
    return AIRating;
}

function byte BestMode()
{
    return 0;
}

function float SuggestAttackStyle()
{
    return 1;
}

function float SuggestDefenseStyle()
{
    return 1;
}

function CalcStuff()
{
    local vector TX,TY,TZ,SX,SY,SZ,CR,CR2,Dir,SpawnDir;
    local int i;
    local vector ATorque;
    local Actor A;

    ClearStayingDebugLines();

    GetAxes(Target.Rotation,TX,TY,TZ);
    GetAxes(AimRot,SX,SY,SZ);

    SpawnDir = vector(AimRot);
    Dir = TargetCOM - AimPos;
    CR = Normal(Dir) cross SpawnDir;
    CR2 =  CR cross Normal(Dir);

    Preview.SetLocation(AimPos);
    Preview.SetRotation(AimRot);

    //DrawStayingDebugLine(AimPos,AimPos+CR*256,255,255,0);
    //DrawStayingDebugLine(AimPos,AimPos+CR2*256,255,128,0);
    //DrawAxes(AimPos,SX,SY,SZ);
    //DrawAxes(TargetCom,TX,TY,TZ);

    TargetDot = Normal(TargetCom-AimPos) dot vector(AimRot);
    TargetAng = TargetDot * VSize(Dir);

    AimSin = sin(TargetDot*pi);
    AimCos = cos(TargetDot*pi);
    Torque = VSize(Dir) * SpawnDir * AimSin;
    AimTau = VSize( Torque );

    for( i=0; i!=Target.Attached.Length; ++i )
    {
        A = JatoProjectile(Target.Attached[i]);
        if( A == None )
            continue;
        ATorque += VSize(TargetCOM - A.Location) * vector(A.Rotation) * sin(Normal(TargetCom-A.Location) dot vector(A.Rotation)*pi);
        //ATorque += (TargetCOM - A.Location) cross vector(A.Rotation);
    }

    TorqueOld = ATorque;
    TorqueNew = ATorque+Torque;

    DrawStayingDebugLine(AimPos,AimPos+Normal(TorqueOld)*256,255,255,0);
    DrawStayingDebugLine(AimPos,AimPos+Normal(TorqueNew)*256,255,0,0);

    SpawnPos = AimPos;
    SpawnRot = AimRot;
}



function DrawAxes( vector loc, vector x, vector y, vector z )
{
    DrawStayingDebugLine(loc,loc+X*256,255,0,0);
    DrawStayingDebugLine(loc,loc+y*256,0,255,0);
    DrawStayingDebugLine(loc,loc+z*256,0,0,255);
}

simulated event RenderOverlays( Canvas C )
{
    local float X,Y;

    Super.RenderOverlays(C);

    if( Target == None )
        return;

    CalcStuff();

    X = 0;
    Y = C.ClipY * 0.5;

    C.DrawColor = TextColor;
    C.Style = ERenderStyle.STY_Normal;

    C.SetPos(X,Y);
    C.DrawText( "Sin" @ GetPropertyText("AimSin") );
    Y += 16;

    C.SetPos(X,Y);
    C.DrawText( "Tau" @ GetPropertyText("AimTau") );
    Y += 16;

    C.SetPos(X,Y);
    C.DrawText( "Torque" @ GetPropertyText("Torque") );
    Y += 16;

    C.SetPos(X,Y);
    C.DrawText( "Torque Old" @ GetPropertyText("TorqueOld") );
    Y += 16;

    C.SetPos(X,Y);
    C.DrawText( "Torque New" @ GetPropertyText("TorqueNew") );
    Y += 16;

    C.SetPos(X,Y);
    C.DrawText( "Torque New" @ VSize(TorqueNew) );
    Y += 16;


}

DefaultProperties
{
    MarkerClass                     = class'JatoMarker'
    PreviewClass                    = class'JatoPreview'
    TextColor                       =(R=255,G=255,B=255,A=255)
    bUseCollisionStaticMesh         = true

    // Other
    ItemName                        = "ACME Jato Kit"
    Description                     = "JATO is a system for helping overloaded planes into the air by providing additional thrust in the form of small rockets. Attaching it to other vehicles or humans is NOT recommended. Brought to you by a company that makes everything."

    DrawType                        = DT_Mesh
    Mesh                            = Mesh'ONSWeapons-A.GrenadeLauncher_1st'

    CenteredOffsetY                 = 10
    CenteredYaw                     = 888
    CenteredRoll                    = 444

    BobDamping                      = 2.2

    DrawScale                       = 1.0
    DisplayFOV                      = 45
    PlayerViewOffset                = (X=150,Y=40,Z=-46)
    PlayerViewPivot                 = (Pitch=0,Roll=0,Yaw=0)
    EffectOffset                    = (X=100.0,Y=32.0,Z=-20.0)
    SmallViewOffset                 = (X=166,Y=48,Z=-54)
    SmallEffectOffset               = (X=0,Y=0,Z=0)


    IconMaterial                    = Material'HudContent.Generic.HUD'
    IconCoords                      = (X1=434,Y1=253,X2=506,Y2=292)

    FireModeClass(0)                = class'JatoFire'
    FireModeClass(1)                = class'JatoFireAlt'
    AttachmentClass                 = class'JatoAttachment'
    PickupClass                     = class'JatoPickup'

    InventoryGroup                  = 7
    GroupOffset                     = 1
    Priority                        = 10

    IdleAnim                        = Idle
    RestAnim                        = Rest
    AimAnim                         = Aim
    RunAnim                         = Run
    SelectAnim                      = Select
    PutDownAnim                     = PutDown

    IdleAnimRate                    = 0.3
    RestAnimRate                    = 1.0
    AimAnimRate                     = 1.0
    RunAnimRate                     = 1.0
    SelectAnimRate                  = 3.1
    PutDownAnimRate                 = 2.8

    PutDownTime                     = 0.33
    BringUpTime                     = 0.33

    SelectSound                     = Sound'WeaponSounds.FlakCannon.SwitchToFlakCannon'
    SelectForce                     = "SwitchToFlakCannon"

    AIRating                        = -1
    CurrentRating                   = -1

    bShowChargingBar                = True
    bCanThrow                       = True

    HudColor                        = (r=0,g=0,b=255,a=255)

    CustomCrosshair                 = 15
    CustomCrosshairTextureName      = "ONSInterface-TX.grenadeLauncherReticle"
    CustomCrosshairColor            = (r=255,g=255,b=255,a=255)
    CustomCrossHairScale            = 1

}