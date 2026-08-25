params [["_force",false,[true]],["_debug",false,[true]]];

if (!hasInterface) exitWith {createHashMap};

private _item=hmd player;
private _old=missionNamespace getVariable ["ZuluFX_nvgClass",""];
private _changed=_item isNotEqualTo _old;

if (!_force && {!_changed}) exitWith {
    missionNamespace getVariable ["ZuluFX_nvgProfile",createHashMap]
};

if (_changed) then {
    ZuluFX_fusionCyclePending=-1;
    ZuluFX_fusionReentry=false;

    if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
        [] call ZuluFX_fnc_cleanupFusion;
    };
};

private _profile=[_item] call ZuluFX_fnc_getNVGProfile;

ZuluFX_nvgProfile=_profile;
ZuluFX_nvgClass=_profile get "class";
ZuluFX_nvgSupported=_profile get "supported";
ZuluFX_nvgTubeMode=_profile get "tubeMode";
ZuluFX_nvgFusionCapable=_profile get "fusionCapable";
ZuluFX_nvgFusionFOV=_profile get "fusionFOV";
ZuluFX_nvgFusionModes=_profile get "fusionModes";
ZuluFX_nvgFusionDefaultMode=_profile get "fusionDefaultMode";
ZuluFX_nvgFusionPatrolRange=_profile get "fusionPatrolRange";
ZuluFX_nvgFusionOutlineRange=_profile get "fusionOutlineRange";
ZuluFX_nvgFusionMaxRange=_profile get "fusionMaxRange";
ZuluFX_nvgCompassCapable=_profile get "compassCapable";
ZuluFX_nvgCompassAnchor=_profile get "compassAnchor";
ZuluFX_nvgHUDMode=_profile get "hudMode";
ZuluFX_nvgBatteryIndicator=_profile get "batteryIndicator";
ZuluFX_nvgBatteryIndicatorAnchor=_profile get "batteryIndicatorAnchor";

private _mode=missionNamespace getVariable ["ZuluFX_fusionMode",ZuluFX_nvgFusionDefaultMode];

if (_changed && {ZuluFX_nvgClass!=""}) then {
    private _key=format ["ZuluFX_fusionMode_%1",toLower ZuluFX_nvgClass];
    _mode=profileNamespace getVariable [_key,ZuluFX_nvgFusionDefaultMode];
};

_mode=toUpper _mode;
if !(_mode in ZuluFX_nvgFusionModes) then {
    _mode=ZuluFX_nvgFusionDefaultMode;
};

ZuluFX_fusionMode=_mode;

if (_changed) then {
    ZuluFX_fusionVisionState=if ([] call ZuluFX_fnc_isNVGActive) then {1} else {0};
    ZuluFX_hudDataNextUpdate=0;
};

if (_debug) then {
    systemChat format [
        "ZuluFX HW | %1 | T:%2 | F:%3 %4deg | HUD:%5 | BAT:%6",
        ZuluFX_nvgClass,
        ZuluFX_nvgTubeMode,
        ZuluFX_nvgFusionCapable,
        ZuluFX_nvgFusionFOV,
        ZuluFX_nvgHUDMode,
        ZuluFX_nvgBatteryIndicator
    ];
};

_profile
