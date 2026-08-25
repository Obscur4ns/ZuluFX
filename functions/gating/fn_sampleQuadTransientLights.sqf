if (!hasInterface || {!ZuluFX_nvgActive}) exitWith {[0,0,0,0]};

private _lights=missionNamespace getVariable ["ZuluFX_transientLights",[]];
if (_lights isEqualTo []) exitWith {[0,0,0,0]};

private _now=diag_tickTime;
private _live=[];
private _eye=eyePos player;
private _c0=positionCameraToWorld [0,0,0];
private _cF=vectorNormalized ((positionCameraToWorld [0,0,1]) vectorDiff _c0);
private _cR=vectorNormalized ((positionCameraToWorld [1,0,0]) vectorDiff _c0);
private _centres=missionNamespace getVariable ["ZuluFX_quadTubeCentres",[0.275,0.425,0.575,0.725]];
private _sigma=missionNamespace getVariable ["ZuluFX_quadSigma",0.13];
private _out=[0,0,0,0];
private _ambientGun=0;

{
    _x params ["_pos","_power","_expiry","_kind"];
    if (_expiry>_now) then {
        _live pushBack _x;
        if (_kind==1) then {
            private _remaining=_expiry-_now;
            if (_remaining<0.25) then {_power=_power*((_remaining/0.25) max 0)};
        };
        private _d=_eye distance _pos;
        private _e=_power/(1+((_d/50)^2));
        if (_e>=0.1) then {
            private _ambientMax=[0.6,0.35] select (_kind==1);
            private _ratio=_d/15;
            private _ambient=(1/(1+(_ratio^2))) min _ambientMax;
            private _ambientE=_e*_ambient;
            if (_kind==1) then {_ambientGun=_ambientGun+_ambientE} else {for "_i" from 0 to 3 do {_out set [_i,(_out select _i)+_ambientE]}};
            private _direct=_e*(1-_ambient);
            private _v=vectorNormalized (_pos vectorDiff _eye);
            if ((_v vectorDotProduct _cF)>0.2 && {_direct>0.05}) then {
                private _scr=worldToScreen _pos;
                private _sx=-99;
                if ((count _scr)>1) then {_sx=_scr select 0} else {_sx=if ((_v vectorDotProduct _cR)>0) then {1.1} else {-0.1}};
                private _atten=1;
                if (_sx<0 || {_sx>1}) then {
                    private _over=if (_sx<0) then {-_sx} else {_sx-1};
                    _atten=if (_over>0.75) then {0} else {0.5*(1-(_over/0.75))};
                };
                if (_atten>0) then {
                    private _eDir=_direct*_atten;
                    for "_i" from 0 to 3 do {
                        private _dx=(_sx-(_centres select _i))/_sigma;
                        _out set [_i,(_out select _i)+(_eDir*exp(-0.5*(_dx^2)))];
                    };
                };
            };
        };
    };
} forEach _lights;

private _gun=_ambientGun min 28;
for "_i" from 0 to 3 do {_out set [_i,(_out select _i)+_gun]};
ZuluFX_transientLights=_live;
_out