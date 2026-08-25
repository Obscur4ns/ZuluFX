if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {ZuluFX_persistentLights = []};

private _eye = eyePos player;
private _cand = [];
private _tick = missionNamespace getVariable ["ZuluFX_persistentScanTick",0];
private _cache = missionNamespace getVariable ["ZuluFX_persistentScanCache",[[],[],[],[]]];
ZuluFX_persistentScanTick = _tick + 1;

private _add = {
    params ["_obj","_power",["_z",0],["_pos",[]]];
    if (isNull _obj && {_pos isEqualTo []}) exitWith {};
    if (_pos isEqualTo []) then {_pos = (getPosASL _obj) vectorAdd [0,0,_z]};
    private _d = _eye distance _pos;
    private _e = _power / (1 + ((_d / 50) ^ 2));
    _cand pushBack [_e,count _cand,_pos,_power,_obj];
};

{[_x,100] call _add} forEach (nearestObjects [player,["FlareCore"],500]);

if ((_tick mod 2) == 0) then {
    private _fire = [];
    { _fire pushBack [_x,60,0.15] } forEach (nearestObjects [player,["NVG_TargetC","IRStrobeBase"],300]);
    { _fire pushBack [_x,1.1,0.15] } forEach (nearestObjects [player,["Chemlight_base"],300]);
    private _classes = missionNamespace getVariable ["ZuluFX_fireClasses",[]];
    if !(_classes isEqualTo []) then {
        { _fire pushBack [_x,20,0.4] } forEach (nearestObjects [player,_classes,300]);
    };
    _cache set [0,_fire];
};

{
    _x params ["_obj","_power","_z"];
    if (!isNull _obj) then {[_obj,_power,_z] call _add};
} forEach (_cache select 0);

if ((_tick mod 4) == 0) then {
    _cache set [1,player nearEntities [["Car","Tank","Air","Ship"],800]];
    _cache set [2,nearestObjects [player,["Lamps_base_F","PowerLines_base_F"],150]];
    _cache set [3,player nearEntities [["Man"],400]];
};

{
    if (!isNull _x) then {
        if (isLightOn _x) then {[_x,25,1.0] call _add};
        if (damage _x >= 1) then {[_x,20,1.0] call _add};
    };
} forEach (_cache select 1);

{
    if (!isNull _x && {damage _x < 1}) then {[_x,15,3.0] call _add};
} forEach (_cache select 2);

{
    if (!isNull _x && {_x != player} && {alive _x} && {isNull objectParent _x}) then {
        private _w = currentWeapon _x;
        if (_w != "" && {_x isFlashlightOn _w}) then {
            private _pos = (getPosASL _x) vectorAdd [0,0,1.5];
            private _dir = _x weaponDirection _w;
            private _face = (_dir vectorDotProduct (vectorNormalized (_eye vectorDiff _pos))) max 0;
            private _power = 50 * (0.25 + (0.75 * _face));
            [_x,_power,0,_pos] call _add;
        };
    };
} forEach (_cache select 3);

ZuluFX_persistentScanCache = _cache;
_cand sort false;
if ((count _cand) > 12) then {_cand resize 12};

private _lights = [];
{
    _x params ["","","_pos","_power","_obj"];
    private _hit = lineIntersectsSurfaces [_eye,_pos,player,_obj,true,1];
    if !(_hit isEqualTo []) then {_power = _power * 0.12};
    _lights pushBack [_pos,_power];
} forEach _cand;

ZuluFX_persistentLights = _lights;