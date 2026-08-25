if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {[0,0,0,0]};

private _eye=eyePos player;
private _c0=positionCameraToWorld [0,0,0];
private _cF=vectorNormalized ((positionCameraToWorld [0,0,1]) vectorDiff _c0);
private _cR=vectorNormalized ((positionCameraToWorld [1,0,0]) vectorDiff _c0);
private _centres=missionNamespace getVariable ["ZuluFX_quadTubeCentres",[0.275,0.425,0.575,0.725]];
private _sigma=missionNamespace getVariable ["ZuluFX_quadSigma",0.13];
private _out=[0,0,0,0];

private _evaluate={
    params ["_pos","_power"];
    private _d=_eye distance _pos;
    private _e=_power/(1+((_d/50)^2));
    private _ambientFrac=(1/(1+((_d/15)^2))) min 0.35;
    private _ambient=_e*_ambientFrac;
    private _v=vectorNormalized (_pos vectorDiff _eye);
    private _r=[_ambient,_ambient,_ambient,_ambient];
    if ((_v vectorDotProduct _cF)>0.1) then {
        private _scr=worldToScreen (ASLToAGL _pos);
        private _sx=-99;
        if ((count _scr)>1) then {_sx=_scr select 0} else {_sx=if ((_v vectorDotProduct _cR)>0) then {1.1} else {-0.1}};
        private _atten=1;
        if (_sx<0 || {_sx>1}) then {
            private _over=if (_sx<0) then {-_sx} else {_sx-1};
            _atten=if (_over>=0.75) then {0} else {0.5*(1-(_over/0.75))};
        };
        if (_atten>0) then {
            private _direct=_e*(1-_ambientFrac)*_atten;
            for "_i" from 0 to 3 do {
                private _dx=(_sx-(_centres select _i))/_sigma;
                _r set [_i,(_r select _i)+(_direct*exp(-0.5*(_dx^2)))];
            };
        };
    };
    _r
};

{
    _x params ["_pos","_power"];
    private _v=[_pos,_power] call _evaluate;
    for "_i" from 0 to 3 do {_out set [_i,(_out select _i) max (_v select _i)]};
} forEach (missionNamespace getVariable ["ZuluFX_persistentLights",[]]);

private _w=currentWeapon player;
if (_w!="" && {player isFlashlightOn _w}) then {
    private _hit=lineIntersectsSurfaces [_eye,_eye vectorAdd (_cF vectorMultiply 150),player,objNull,true,1];
    if !(_hit isEqualTo []) then {
        private _v=[(_hit select 0) select 0,50] call _evaluate;
        for "_i" from 0 to 3 do {_out set [_i,(_out select _i) max (_v select _i)]};
    };
};

_out