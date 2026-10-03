if (!hasInterface || {isNull player} || {!alive player}) exitWith {false};

private _item=hmd player;
if (_item=="") exitWith {false};

if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgSupported",false]) exitWith {false};
if !([] call ZuluFX_fnc_isNVGActive) exitWith {false};

private _hudMode=toUpper (missionNamespace getVariable ["ZuluFX_nvgHUDMode","NONE"]);
private _battery=toUpper (missionNamespace getVariable ["ZuluFX_nvgBatteryIndicator","NONE"]);
private _batteryEnabled=missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true];

(_hudMode!="NONE") || {_batteryEnabled && {_battery!="NONE"}}
