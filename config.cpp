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

class RscMapControl;

class ZuluFX_RscFusionMap: RscMapControl
{
    x="safeZoneXAbs";
    y="safeZoneY";
    w="safeZoneWAbs";
    h="safeZoneH";
    fade=1;
    showMarkers=0;
    drawObjects=0;
    moveOnEdges=0;
    maxSatelliteAlpha=0;
    alphaFadeStartScale=0;
    alphaFadeEndScale=0;
    showCountourInterval=0;
    scaleMin=0.0001;
    scaleMax=1;
    scaleDefault=0.001;
    colorBackground[]={0,0,0,0};
    colorOutside[]={0,0,0,0};
    colorSea[]={0,0,0,0};
    colorText[]={0,0,0,0};
    colorLevels[]={0,0,0,0};
    colorCountlines[]={0,0,0,0};
    colorMainCountlines[]={0,0,0,0};
    colorCountlinesWater[]={0,0,0,0};
    colorMainCountlinesWater[]={0,0,0,0};
    colorForest[]={0,0,0,0};
    colorForestBorder[]={0,0,0,0};
    colorRocks[]={0,0,0,0};
    colorRocksBorder[]={0,0,0,0};
    colorPowerLines[]={0,0,0,0};
    colorRailWay[]={0,0,0,0};
    colorNames[]={0,0,0,0};
    colorInactive[]={0,0,0,0};
    colorTracks[]={0,0,0,0};
    colorTracksFill[]={0,0,0,0};
    colorRoads[]={0,0,0,0};
    colorRoadsFill[]={0,0,0,0};
    colorMainRoads[]={0,0,0,0};
    colorMainRoadsFill[]={0,0,0,0};
    colorGrid[]={0,0,0,0};
    colorGridMap[]={0,0,0,0};
    colorTrails[]={0,0,0,0};
    colorTrailsFill[]={0,0,0,0};
};

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
