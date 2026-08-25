if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_quadExposureTarget=[0,0,0,0];
    ZuluFX_quadExposure=[0,0,0,0];
    ZuluFX_quadGateActive=[0,0,0,0];
    ZuluFX_quadGateDeficit=[0,0,0,0];
    ZuluFX_quadGates=[0,0,0,0];
    ZuluFX_quadUpdateFault=[];
    ZuluFX_quadUpdateStage=0;
    ZuluFX_quadGateLastTime=diag_tickTime;
};

ZuluFX_quadUpdateStage=1;

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_quadGateLastTime",_now-0.05];
private _dt=(_now-_last) max 0;
if (_dt>0.25) then {_dt=0.25};
ZuluFX_quadGateLastTime=_now;
if (_dt<=0) exitWith {ZuluFX_quadUpdateStage=2};

ZuluFX_quadUpdateStage=3;

private _raw=call ZuluFX_fnc_calculateQuadExposure;
ZuluFX_quadUpdateRaw=_raw;

if ((count _raw)!=4) exitWith {
    ZuluFX_quadUpdateFault=["RAW",_raw];
    ZuluFX_quadUpdateStage=-3;
};

ZuluFX_quadUpdateFault=[];
ZuluFX_quadUpdateStage=4;

private _eff=[0,0,0,0];
private _bleed=0.15;

for "_i" from 0 to 3 do {
    private _v=_raw select _i;

    if (_i>0) then {
        private _left=(_raw select (_i-1))*_bleed;
        if (_left>_v) then {_v=_left};
    };

    if (_i<3) then {
        private _right=(_raw select (_i+1))*_bleed;
        if (_right>_v) then {_v=_right};
    };

    if (_v<0) then {_v=0};
    if (_v>1) then {_v=1};

    _eff set [_i,_v];
};

ZuluFX_quadExposureTarget=_eff;
ZuluFX_quadUpdateStage=5;

private _adapt=missionNamespace getVariable ["ZuluFX_quadExposure",[0,0,0,0]];
if ((count _adapt)!=4) then {_adapt=[0,0,0,0]};

private _tauAttack=0.06;
private _tauRecover=0.30;

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

ZuluFX_quadExposure=_adapt;
ZuluFX_quadUpdateStage=6;

private _active=[0,0,0,0];
private _deficit=[0,0,0,0];
private _output=[0,0,0,0];

private _maxGate=0.30;
private _gateHalf=0.22;
private _sceneFloor=0.05;
private _deficitK=0.05;
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
        private _excess=_ratio-1;
        if (_excess<0) then {_excess=0};

        _d=1-(1/(1+(_deficitK*_excess)));
    };

    private _out=_g*_strength;
    if (_out>_alphaCeil) then {_out=_alphaCeil};

    _active set [_i,_g];
    _deficit set [_i,_d];
    _output set [_i,_out];
};

ZuluFX_quadGateActive=_active;
ZuluFX_quadGateDeficit=_deficit;
ZuluFX_quadGates=_output;
ZuluFX_quadUpdateStage=7;