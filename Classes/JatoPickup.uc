//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoPickup extends UTWeaponPickup;

DefaultProperties
{
    InventoryType               = class'JatoGun'

    PickupMessage               = "You got the ACME Jato Kit."
    PickupSound                 = Sound'PickupSounds.FlakCannonPickup'
    PickupForce                 = "ONSGrenadePickup"

    MaxDesireability            = 0.7

    DrawScale                   = 0.25
    DrawType                    = DT_StaticMesh
    StaticMesh                  = StaticMesh'ONSWeapons-SM.GrenadeLauncherPickup'

    Standup                     = (Y=0.25,Z=0.0)

    TransientSoundVolume        = 1.0
    TransientSoundRadius        = 300.0
}