//=============================================================================
// Jato
//=============================================================================
// Coded by Roman Switch` Dzieciol (C) 2005
//=============================================================================
class JatoAmmoPickup extends UTAmmoPickup;

DefaultProperties
{
    InventoryType           = class'JatoAmmo'

    PickupMessage           = "You picked up some Jato kits"
    PickupSound             = Sound'PickupSounds.FlakAmmoPickup'
    PickupForce             = "FlakAmmoPickup"

    AmmoAmount              = 5

    DrawScale               = 0.25
    StaticMesh              = StaticMesh'ONSWeapons-SM.GrenadeLauncherAmmo'
    DrawType                = DT_StaticMesh
}