params [["_pos",[0,0,0],[[]],3],["_power",0,[0]],["_life",0.12,[0]],["_kind",0,[0]]];
if (!hasInterface || {!ZuluFX_nvgActive} || {_power <= 0}) exitWith {};

private _lights = missionNamespace getVariable ["ZuluFX_transientLights",[]];
private _expiry = diag_tickTime + (_life max 0.01);
private _merged = false;

{
    if (_kind isEqualTo (_x select 3) && {_pos distance (_x select 0) < 2}) exitWith {
        _x set [0,_pos];
        _x set [1,_power max (_x select 1)];
        _x set [2,_expiry max (_x select 2)];
        _merged = true;
    };
} forEach _lights;

if (!_merged) then {
    if (count _lights < 16) then {
        _lights pushBack [_pos,_power,_expiry,_kind];
    } else {
        private _idx = 0;
        private _weak = (_lights select 0) select 1;
        {
            if ((_x select 1) < _weak) then {_weak = _x select 1; _idx = _forEachIndex};
        } forEach _lights;
        if (_power > _weak) then {_lights set [_idx,[_pos,_power,_expiry,_kind]]};
    };
};

ZuluFX_transientLights = _lights;