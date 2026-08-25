if (!hasInterface || {isNull player}) exitWith {0};
private _start = eyePos player;
private _ignore = vehicle player;
if (_ignore isEqualTo player) then {_ignore = objNull};
private _directions = [[0,0,1],[0.5,0,0.866],[-0.5,0,0.866],[0,0.5,0.866],[0,-0.5,0.866]];
private _clear = 0;
{
    private _end = _start vectorAdd (_x vectorMultiply 100);
    if ((lineIntersectsSurfaces [_start,_end,player,_ignore,true,1,"VIEW","NONE"]) isEqualTo []) then {_clear = _clear + 1};
} forEach _directions;
_clear / count _directions