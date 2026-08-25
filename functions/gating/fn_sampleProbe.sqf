if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {[0,0]};
if (isNil "ZuluFX_gateProbe" || {isNull ZuluFX_gateProbe}) then {call ZuluFX_fnc_createProbe};
private _start = AGLToASL positionCameraToWorld [0,0,0];
private _end = AGLToASL positionCameraToWorld [0,0,100];
private _vehicle = vehicle player;
private _ignore = if (_vehicle isEqualTo player) then {objNull} else {_vehicle};
private _hits = lineIntersectsSurfaces [_start,_end,player,_ignore,true,1,"VIEW","NONE"];
private _position = if (_hits isEqualTo []) then {AGLToASL positionCameraToWorld [0,0,25]} else {(_hits select 0) select 0};
ZuluFX_gateProbe setPosASL _position;
private _lighting = getLightingAt ZuluFX_gateProbe;
[_lighting select 1,_lighting select 3]