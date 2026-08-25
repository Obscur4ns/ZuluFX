if (!hasInterface) exitWith {};

ZuluFX_compassEnabled=true;
ZuluFX_hudModeActive="";
ZuluFX_hudClassActive="";
ZuluFX_hudPFH=nil;
ZuluFX_hudDataCache=createHashMap;
ZuluFX_hudDataNextUpdate=0;

if (isNil "ZuluFX_nvgBatteryLow") then {
    ZuluFX_nvgBatteryLow=false;
};

if (isNil "ZuluFX_nvgBatteryLevel") then {
    ZuluFX_nvgBatteryLevel=-1;
};

uiNamespace setVariable ["ZuluFX_bnvdfControls",[]];
uiNamespace setVariable ["ZuluFX_fpanoControls",[]];
uiNamespace setVariable ["ZuluFX_batteryIndicatorControl",controlNull];

["visionMode",{
    params ["_unit","_newMode"];

    if (_unit isNotEqualTo player) exitWith {};

    if (_newMode==1) then {
        if ([] call ZuluFX_fnc_canUseHUD) then {
            [] call ZuluFX_fnc_createHUD;
        };
    } else {
        [] call ZuluFX_fnc_cleanupHUD;
    };
},true] call CBA_fnc_addPlayerEventHandler;

["loadout",{
    [false,false] call ZuluFX_fnc_updateNVGProfile;

    if ([] call ZuluFX_fnc_canUseHUD) then {
        [] call ZuluFX_fnc_createHUD;
    } else {
        [] call ZuluFX_fnc_cleanupHUD;
    };
}] call CBA_fnc_addPlayerEventHandler;

[{
    [true,false] call ZuluFX_fnc_updateNVGProfile;

    if ([] call ZuluFX_fnc_canUseHUD) then {
        [] call ZuluFX_fnc_createHUD;
    };
}] call CBA_fnc_execNextFrame;
