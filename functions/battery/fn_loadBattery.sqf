if (!hasInterface || {isNull player}) exitWith {false};

if !(missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true]) exitWith {false};
if !(missionNamespace getVariable ["ZuluFX_nvgBatteryCapable",false]) exitWith {false};

private _max=missionNamespace getVariable ["ZuluFX_nvgMaxBatteries",0];
if (_max<=0) exitWith {false};

private _batteryClass="ZuluFX_Battery_CR123A";

if !([player,_batteryClass] call ace_common_fnc_hasItem) exitWith {
    ["No CR123A Available",1.2] call CBA_fnc_notify;
    false
};

private _state=[] call ZuluFX_fnc_getBatteryState;
private _level=_state#0;
private _cells=_state#1;

if (_cells>=_max && {_level>=0.999}) exitWith {false};

if ([] call ZuluFX_fnc_isNVGActive) then {
    ZuluFX_fusionCyclePending=-1;
    ZuluFX_fusionReentry=false;
    ZuluFX_fusionVisionState=0;

    if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
        [false] call ZuluFX_fnc_setFusion;
    };

    player action ["NVGogglesOff",player];
};

player removeItem _batteryClass;

if (_cells<_max) then {
    private _energy=_level*_cells;
    _cells=_cells+1;
    _level=((_energy+1)/_cells) min 1;
} else {
    _level=(_level+(1/_max)) min 1;
};

private _key=[] call ZuluFX_fnc_getBatteryStateKey;
private _states=missionNamespace getVariable ["ZuluFX_batteryStates",createHashMap];
_states set [_key,[_level,_cells]];
ZuluFX_batteryStates=_states;
ZuluFX_batteryPersistenceDirty=true;

ZuluFX_nvgBatteryLevel=_level;
ZuluFX_nvgLoadedBatteries=_cells;

private _required=missionNamespace getVariable ["ZuluFX_nvgRequiredBatteries",1];
private _threshold=missionNamespace getVariable ["ZuluFX_nvgBatteryLowThreshold",0.20];

ZuluFX_nvgBatteryLow=
    _level>0 &&
    {_level<=_threshold} &&
    {_cells>=_required};

ZuluFX_batteryLastTick=diag_tickTime;

[true] call ZuluFX_fnc_saveBatteryStates;
["CR123A Loaded",1.2] call CBA_fnc_notify;

true
