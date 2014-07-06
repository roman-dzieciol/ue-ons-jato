//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoMarker extends Actor;

simulated function AdjustDrawScale( float Radius, float Height )
{
    local vector NewScale;

    NewScale.X = Radius / 128;
    NewScale.Y = Radius / 128;
    NewScale.Z = Height / 128;

    NewScale *= vect(1.5,1.5,2.0);

    SetDrawScale3D(NewScale);
}

DefaultProperties
{
    bHidden=True
    bUnlit=True
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'ONSJatoSM.JatoMarker'
}