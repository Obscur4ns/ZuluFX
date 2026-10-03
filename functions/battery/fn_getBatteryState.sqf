params [["_key","",[""]]];

if (!hasInterface) exitWith {[-1,0]};

if (_key=="") then {
    _key=[] call ZuluFX_fnc_getBatteryStateKey;
};

if (_key=="") exitWith {[-1,0]};

private _max=missionNamespace getVariable ["ZuluFX_nvgMaxBatteries",0];
private _states=missionNamespace getVariable ["ZuluFX_batteryStates",createHashMap];
private _state=_states getOrDefault [_key,[]];

if ((count _state)!=2) then {
    _state=[1,_max];
};

private _level=(_state#0 max 0) min 1;
private _cells=(round (_state#1)) max 0;
_cells=_cells min _max;

_state=[_level,_cells];
_states set [_key,_state];
ZuluFX_batteryStates=_states;

_state
