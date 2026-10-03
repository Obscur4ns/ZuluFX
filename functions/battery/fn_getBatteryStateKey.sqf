if (!hasInterface || {isNull player}) exitWith {""};

private _key=missionNamespace getVariable ["ZuluFX_nvgBatteryStateKey",""];

if (_key=="") then {
    _key=missionNamespace getVariable ["ZuluFX_nvgClass",""];
};

toLower _key
