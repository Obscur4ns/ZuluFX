params [["_force",false,[true]]];

if (!hasInterface || {isNull player}) exitWith {false};

if (
    !_force &&
    {!(missionNamespace getVariable ["ZuluFX_batteryPersistenceDirty",false])}
) exitWith {true};

private _storageKey=missionNamespace getVariable ["ZuluFX_batteryPersistenceKey",""];

if (_storageKey=="") then {
    private _uid=getPlayerUID player;
    if (_uid=="") then {_uid="local"};
    _storageKey=format ["ZuluFX_BatteryStates_v1_%1",_uid];
    ZuluFX_batteryPersistenceKey=_storageKey;
};

private _states=missionNamespace getVariable ["ZuluFX_batteryStates",createHashMap];
private _entries=[];

{
    private _state=_states getOrDefault [_x,[]];

    if (_state isEqualType [] && {(count _state)==2}) then {
        private _level=(_state#0 max 0) min 1;
        private _cells=(round (_state#1)) max 0;
        _entries pushBack [_x,_level,_cells];
    };
} forEach (keys _states);

profileNamespace setVariable [_storageKey,[1,_entries]];
saveProfileNamespace;

ZuluFX_batteryPersistenceDirty=false;
ZuluFX_batteryPersistenceNextSave=diag_tickTime+30;

true
