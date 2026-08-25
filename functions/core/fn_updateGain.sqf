if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_targetGain=1;
    ZuluFX_gain=1;
    ZuluFX_gainLastTime=diag_tickTime;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_gainLastTime",_now-0.05];
private _dt=_now-_last;
if (_dt<0) then {_dt=0};
if (_dt>0.25) then {_dt=0.25};
ZuluFX_gainLastTime=_now;
if (_dt<=0) exitWith {};

private _target=call ZuluFX_fnc_calculateGain;
private _current=missionNamespace getVariable ["ZuluFX_gain",1];
private _tau=1.10;

if (_target<_current) then {_tau=0.12};

private _k=1 - exp (-_dt / _tau);
private _value=_current+((_target-_current)*_k);

if (_value<0.35) then {_value=0.35};
if (_value>1.35) then {_value=1.35};

ZuluFX_targetGain=_target;
ZuluFX_gain=_value;