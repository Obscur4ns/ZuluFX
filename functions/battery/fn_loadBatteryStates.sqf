if (!hasInterface || {isNull player}) exitWith {false};

private _uid=getPlayerUID player;
if (_uid=="") then {_uid="local"};

private _storageKey=format ["ZuluFX_BatteryStates_v1_%1",_uid];
ZuluFX_batteryPersistenceKey=_storageKey;

private _saved=profileNamespace getVariable [_storageKey,[1,[]]];
private _entries=[];

if (
    _saved isEqualType [] &&
    {(count _saved)==2} &&
    {(_saved#0) isEqualType 0} &&
    {(_saved#1) isEqualType []}
) then {
    _entries=_saved#1;
};

private _states=createHashMap;

{
    if (_x isEqualType [] && {(count _x)==3}) then {
        _x params ["_key","_level","_cells"];

        if (
            _key isEqualType "" &&
            {_key!=""} &&
            {_level isEqualType 0} &&
            {_cells isEqualType 0}
        ) then {
            _states set [
                toLower _key,
                [
                    (_level max 0) min 1,
                    (round _cells) max 0
                ]
            ];
        };
    };
} forEach _entries;

ZuluFX_batteryStates=_states;
ZuluFX_batteryPersistenceDirty=false;
ZuluFX_batteryPersistenceNextSave=diag_tickTime+30;

true
