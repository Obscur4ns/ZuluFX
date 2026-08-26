params [
    ["_level",1,[0]],
    ["_key","",[""]]
];

if (!hasInterface) exitWith {-1};

if (_key=="") then {
    _key=[] call ZuluFX_fnc_getBatteryStateKey;
};

if (_key=="") exitWith {-1};

_level=(_level max 0) min 1;

private _state=[_key] call ZuluFX_fnc_getBatteryState;

if (_level<=0) then {
    _state=[0,0];
} else {
    _state set [0,_level];
};

private _states=missionNamespace getVariable ["ZuluFX_batteryStates",createHashMap];
_states set [_key,_state];
ZuluFX_batteryStates=_states;
ZuluFX_batteryPersistenceDirty=true;

private _current=[] call ZuluFX_fnc_getBatteryStateKey;

if (_key==_current) then {
    ZuluFX_nvgBatteryLevel=_state#0;
    ZuluFX_nvgLoadedBatteries=_state#1;

    private _required=missionNamespace getVariable ["ZuluFX_nvgRequiredBatteries",1];
    private _threshold=missionNamespace getVariable ["ZuluFX_nvgBatteryLowThreshold",0.20];

    ZuluFX_nvgBatteryLow=
        ZuluFX_nvgBatteryLevel>0 &&
        {ZuluFX_nvgBatteryLevel<=_threshold} &&
        {ZuluFX_nvgLoadedBatteries>=_required};
};

_level
