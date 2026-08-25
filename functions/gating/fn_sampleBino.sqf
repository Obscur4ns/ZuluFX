if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {[0,0]};
if (isNil "ZuluFX_gateProbe" || {isNull ZuluFX_gateProbe}) then {call ZuluFX_fnc_createProbe};

private _xs=missionNamespace getVariable ["ZuluFX_binoSampleXs",[0.30,0.3667,0.4333,0.50,0.5667,0.6333,0.70]];
private _ys=missionNamespace getVariable ["ZuluFX_binoSampleYs",[0.36,0.50,0.64]];
private _field=missionNamespace getVariable ["ZuluFX_binoProbeField",[]];
private _count=(count _xs)*(count _ys);
if ((count _field)!=_count) then {_field=[];for "_i" from 0 to (_count-1) do {_field pushBack 0}};

private _phase=missionNamespace getVariable ["ZuluFX_binoProbePhase",0];
private _start=AGLToASL positionCameraToWorld [0,0,0];
private _vehicle=vehicle player;
private _ignore=if (_vehicle isEqualTo player) then {objNull} else {_vehicle};

private _sample={
    params ["_sx","_sy"];
    private _dir=screenToWorldDirection [_sx,_sy];
    private _end=_start vectorAdd (_dir vectorMultiply 100);
    private _hits=lineIntersectsSurfaces [_start,_end,player,_ignore,true,1,"VIEW","NONE"];
    private _pos=if (_hits isEqualTo []) then {_start vectorAdd (_dir vectorMultiply 25)} else {(_hits select 0) select 0};
    ZuluFX_gateProbe setPosASL _pos;
    private _lighting=getLightingAt ZuluFX_gateProbe;
    (_lighting select 3) max 0
};

for "_i" from 0 to ((count _xs)-1) do {
    private _idx=(_phase*(count _xs))+_i;
    _field set [_idx,[_xs select _i,_ys select _phase] call _sample];
};

_field set [10,[0.50,0.50] call _sample];
ZuluFX_binoProbeField=_field;
ZuluFX_binoProbePhase=(_phase+1) mod (count _ys);

private _left=0;
private _right=0;

for "_row" from 0 to ((count _ys)-1) do {
    for "_col" from 0 to ((count _xs)-1) do {
        private _v=_field select ((_row*(count _xs))+_col);
        private _x=_xs select _col;
        if (_x<=0.52 && {_v>_left}) then {_left=_v};
        if (_x>=0.48 && {_v>_right}) then {_right=_v};
    };
};

[_left,_right]