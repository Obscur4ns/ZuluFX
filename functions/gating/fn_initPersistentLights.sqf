if (!hasInterface) exitWith {};
if (!isNil "ZuluFX_persistentPFH") exitWith {};

ZuluFX_persistentLights = [];
ZuluFX_persistentScanTick = 0;
ZuluFX_persistentScanCache = [[],[],[],[]];
ZuluFX_fireClasses = ["Campfire_burning_F","FirePlace_burning_F","MetalBarrel_burning_F","test_EmptyObjectForFireBig"];

[] spawn {
    private _cached = uiNamespace getVariable ["ZuluFX_fireClassCache",[]];
    if !(_cached isEqualTo []) exitWith {ZuluFX_fireClasses = +_cached};
    uiSleep 0.1;
    private _found = ("true" configClasses (configFile >> "CfgVehicles")) select {(toLower configName _x) find "burning" >= 0} apply {configName _x};
    _found pushBackUnique "test_EmptyObjectForFireBig";
    if ((count _found) > 64) then {_found resize 64};
    if !(_found isEqualTo []) then {ZuluFX_fireClasses = _found};
    uiNamespace setVariable ["ZuluFX_fireClassCache",+ZuluFX_fireClasses];
};

ZuluFX_persistentPFH = [{
    if (missionNamespace getVariable ["ZuluFX_nvgActive",false]) then {
        call ZuluFX_fnc_scanPersistentLights;
    } else {
        ZuluFX_persistentLights = [];
        ZuluFX_persistentScanTick = 0;
        ZuluFX_persistentScanCache = [[],[],[],[]];
    };
},0.25] call CBA_fnc_addPerFrameHandler;