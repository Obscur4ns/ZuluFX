if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {[0,0,0,0]};
if (isNil "ZuluFX_gateProbe" || {isNull ZuluFX_gateProbe}) then {call ZuluFX_fnc_createProbe};

private _xs=missionNamespace getVariable ["ZuluFX_quadSampleXs",[0.18,0.26,0.34,0.42,0.50,0.58,0.66,0.74,0.82]];
private _ys=missionNamespace getVariable ["ZuluFX_quadSampleYs",[0.36,0.50,0.64]];
private _centres=missionNamespace getVariable ["ZuluFX_quadTubeCentres",[0.275,0.425,0.575,0.725]];
private _sigma=missionNamespace getVariable ["ZuluFX_quadSigma",0.13];
private _cols=count _xs;
private _rows=count _ys;
private _count=_cols*_rows;
private _field=missionNamespace getVariable ["ZuluFX_quadProbeField",[]];

if ((count _field)!=_count) then {
    _field=[];
    for "_i" from 0 to (_count-1) do {_field pushBack 0};
};

private _phase=(missionNamespace getVariable ["ZuluFX_quadProbePhase",0]) max 0 min (_rows-1);
private _start=AGLToASL (positionCameraToWorld [0,0,0]);
private _vehicle=vehicle player;
private _ignore=if (_vehicle isEqualTo player) then {objNull} else {_vehicle};
private _sy=_ys select _phase;

for "_i" from 0 to (_cols-1) do {
    private _dir=screenToWorldDirection [_xs select _i,_sy];
    private _end=_start vectorAdd (_dir vectorMultiply 100);
    private _hits=lineIntersectsSurfaces [_start,_end,player,_ignore,true,1,"VIEW","NONE"];
    private _pos=if (_hits isEqualTo []) then {_start vectorAdd (_dir vectorMultiply 25)} else {(_hits select 0) select 0};
    ZuluFX_gateProbe setPosASL _pos;
    private _lighting=getLightingAt ZuluFX_gateProbe;
    _field set [(_phase*_cols)+_i,(_lighting select 3) max 0];
};

private _dir=screenToWorldDirection [0.5,0.5];
private _end=_start vectorAdd (_dir vectorMultiply 100);
private _hits=lineIntersectsSurfaces [_start,_end,player,_ignore,true,1,"VIEW","NONE"];
private _pos=if (_hits isEqualTo []) then {_start vectorAdd (_dir vectorMultiply 25)} else {(_hits select 0) select 0};
ZuluFX_gateProbe setPosASL _pos;
private _lighting=getLightingAt ZuluFX_gateProbe;
private _centreIdx=(floor (_cols/2))+_cols;
_field set [_centreIdx,(_lighting select 3) max 0];

ZuluFX_quadProbeField=_field;
ZuluFX_quadProbePhase=(_phase+1) mod _rows;

private _out=[0,0,0,0];
private _range=_sigma*2;

for "_row" from 0 to (_rows-1) do {
    for "_col" from 0 to (_cols-1) do {
        private _v=_field select ((_row*_cols)+_col);
        private _x=_xs select _col;

        for "_tube" from 0 to 3 do {
            private _dist=abs(_x-(_centres select _tube));
            private _w=(1-((_dist/_range) min 1)) max 0;
            _w=_w*_w*(3-(2*_w));
            private _weighted=_v*_w;
            if (_weighted>(_out select _tube)) then {_out set [_tube,_weighted]};
        };
    };
};

ZuluFX_quadProbeOutput=+_out;
_out