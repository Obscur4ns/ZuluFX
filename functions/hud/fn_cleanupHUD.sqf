if (!hasInterface) exitWith {false};

if (!isNil "ZuluFX_hudPFH") then {
    [ZuluFX_hudPFH] call CBA_fnc_removePerFrameHandler;
    ZuluFX_hudPFH=nil;
};

[] call ZuluFX_fnc_cleanupCompass;

disableSerialization;

{
    if (!isNull _x) then {
        ctrlDelete _x;
    };
} forEach (uiNamespace getVariable ["ZuluFX_bnvdfControls",[]]);

{
    if (!isNull _x) then {
        ctrlDelete _x;
    };
} forEach (uiNamespace getVariable ["ZuluFX_fpanoControls",[]]);

private _battery=uiNamespace getVariable ["ZuluFX_batteryIndicatorControl",controlNull];
if (!isNull _battery) then {
    ctrlDelete _battery;
};

uiNamespace setVariable ["ZuluFX_bnvdfControls",[]];
uiNamespace setVariable ["ZuluFX_fpanoControls",[]];
uiNamespace setVariable ["ZuluFX_batteryIndicatorControl",controlNull];

ZuluFX_hudModeActive="";
ZuluFX_hudClassActive="";
true
