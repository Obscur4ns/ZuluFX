class CfgPatches
{
    class ZuluFX
    {
        name="ZuluFX";
        author="UKSF Surplus";
        units[]=
        {
            "ZuluFX_CR123A_Ground"
        };
        weapons[]=
        {
            "ZuluFX_Battery_CR123A"
        };
        requiredVersion=2.20;
        requiredAddons[]=
        {
            "cba_common",
            "cba_main",
            "ace_nightvision",
            "ace_interact_menu",
            "A3_Characters_F",
            "A3_Weapons_F"
        };
    };
};

#include "CfgFunctions.hpp"
#include "CfgFaces.hpp"

class CfgWeapons
{
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class ZuluFX_Battery_CR123A: CBA_MiscItem
    {
        author="UKSF Surplus";
        scope=2;
        scopeArsenal=2;
        displayName="[ZXX] CR123A";
        descriptionShort="CR123A lithium battery for compatible night vision systems.";
        model="\ZuluFX\CR123A.p3d";
        picture="\ZuluFX\logo\cr123a_icon.paa";

        class ItemInfo: CBA_MiscItem_ItemInfo
        {
            mass=1;
        };
    };
};

class CfgVehicles
{
    class Item_Base_F;

    class ZuluFX_CR123A_Ground: Item_Base_F
    {
        author="UKSF Surplus";
        scope=2;
        scopeCurator=2;
        displayName="[ZXX] CR123A";
        vehicleClass="Items";
        editorCategory="EdCat_Equipment";
        editorSubcategory="EdSubcat_InventoryItems";
        model="\ZuluFX\CR123A.p3d";

        class TransportItems
        {
            class ZuluFX_Battery_CR123A
            {
                name="ZuluFX_Battery_CR123A";
                count=1;
            };
        };
    };
};