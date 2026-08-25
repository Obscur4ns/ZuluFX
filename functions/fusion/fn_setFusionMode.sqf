params [
    ["_mode","PATROL",[""]],
    ["_notify",true,[true]]
];

if (!hasInterface || {isNull player}) exitWith {false};

private _item=hmd player;
if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]) exitWith {false};

private _modes=missionNamespace getVariable ["ZuluFX_nvgFusionModes",[]];
_mode=toUpper _mode;

if !(_mode in _modes) exitWith {false};

private _current=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode",""]);
if (_mode isEqualTo _current) exitWith {true};

private _wasActive=missionNamespace getVariable ["ZuluFX_fusionActive",false];

if (_wasActive) then {
    [] call ZuluFX_fnc_cleanupFusion;
};

ZuluFX_fusionMode=_mode;

private _class=missionNamespace getVariable ["ZuluFX_nvgClass",""];
if (_class!="") then {
    profileNamespace setVariable [
        format ["ZuluFX_fusionMode_%1",toLower _class],
        _mode
    ];
    saveProfileNamespace;
};

if (_wasActive && {[] call ZuluFX_fnc_canUseFusion}) then {
    [] call ZuluFX_fnc_createFusion;
};

private _hudMode=toUpper (missionNamespace getVariable ["ZuluFX_nvgHUDMode","NONE"]);
private _hudOwnsModeDisplay=_hudMode in ["BNVDF","FPANO"];

if (_notify && {!_hudOwnsModeDisplay}) then {
    private _label=if (_mode=="OUTLINE") then {"Outline"} else {"Patrol"};
    [format ["ZuluFX Fusion Mode: %1",_label],1.2] call CBA_fnc_notify;
};

true
