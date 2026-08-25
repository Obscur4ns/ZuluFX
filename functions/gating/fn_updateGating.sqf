if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_quadExposureTarget=[0,0,0,0];
    ZuluFX_quadExposure=[0,0,0,0];
    ZuluFX_quadGateActive=[0,0,0,0];
    ZuluFX_quadGateDeficit=[0,0,0,0];
    ZuluFX_quadGates=[0,0,0,0];
    ZuluFX_quadUpdateFault=[];
    ZuluFX_quadGateLastTime=diag_tickTime;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_quadGateLastTime",_now-0.05];
private _dt=(_now-_last) max 0;
if (_dt>0.25) then {_dt=0.25};
ZuluFX_quadGateLastTime=_now;
if (_dt<=0) exitWith {};

private _raw=call ZuluFX_fnc_calculateQuadExposure;
if ((count _raw)!=4) exitWith {ZuluFX_quadUpdateFault=["RAW",_raw]};

private _eff=[];
private _bleed=0.15;

for "_i" from 0 to 3 do {
    private _v=_raw select _i;
    if (_i>0) then {
        private _n=(_raw select (_i-1))*_bleed;
        if (_n>_v) then {_v=_n};
    };
    if (_i<3) then {
        private _n=(_raw select (_i+1))*_bleed;
        if (_n>_v) then {_v=_n};
    };
    if (_v<0) then {_v=0};
    if (_v>1) then {_v=1};
    _eff pushBack _v;
};

private _stored=missionNamespace getVariable ["ZuluFX_quadExposure",[0,0,0,0]];
private _adapt=[];
{_adapt pushBack _x} forEach _stored;

private _tauAttack=0.08;
private _tauRecover=0.85;

for "_i" from 0 to 3 do {
    private _target=_eff select _i;
    private _current=_adapt select _i;
    private _tau=_tauRecover;
    if (_target>_current) then {_tau=_tauAttack};
    private _k=1 - exp (-_dt/_tau);
    private _value=_current+((_target-_current)*_k);
    if (_value<0) then {_value=0};
    if (_value>1) then {_value=1};
    _adapt set [_i,_value];
};

private _active=[];
private _deficit=[];
private _output=[];
private _maxGate=0.30;
private _gateHalf=0.22;
private _sceneFloor=0.05;
private _deficitK=0.05;
private _maxTubeAtten=0.72;
private _strength=2.3;
private _alphaCeil=0.92;

for "_i" from 0 to 3 do {
    private _a=_adapt select _i;
    private _scene=_eff select _i;
    private _g=(_maxGate*_a)/(_a+_gateHalf);
    private _d=0;

    if (_a>_scene) then {
        private _floor=_scene;
        if (_floor<_sceneFloor) then {_floor=_sceneFloor};
        private _ratio=_a/_floor;
        private _excess=(_ratio-1) max 0;
        _d=1-(1/(1+(_deficitK*_excess)));
    };

    private _dark=_g max _d;
    if (_dark>_maxTubeAtten) then {_dark=_maxTubeAtten};

    private _out=_dark*_strength;
    if (_out>_alphaCeil) then {_out=_alphaCeil};

    _active pushBack _g;
    _deficit pushBack _d;
    _output pushBack _out;
};

ZuluFX_quadExposureTarget=_eff;
ZuluFX_quadExposure=_adapt;
ZuluFX_quadGateActive=_active;
ZuluFX_quadGateDeficit=_deficit;
ZuluFX_quadGates=_output;
ZuluFX_quadUpdateFault=[];