if (ZuluFX_ppGrain<0) exitWith {};

if (missionNamespace getVariable ["ZuluFX_debugVisualBypass",false]) exitWith {
    ZuluFX_ppGrain ppEffectEnable false;
};

if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_grainTarget=0;
    ZuluFX_grainIntensity=0;
    ZuluFX_grainDrive=0;
    ZuluFX_grainLastTime=diag_tickTime;
    ZuluFX_ppGrain ppEffectEnable false;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_grainLastTime",_now-0.1];
private _dt=_now-_last;
if (_dt<0) then {_dt=0};
if (_dt>0.25) then {_dt=0.25};
ZuluFX_grainLastTime=_now;
if (_dt<=0) exitWith {};

private _target=call ZuluFX_fnc_calculateGrain;
private _current=missionNamespace getVariable ["ZuluFX_grainIntensity",0.04];
private _tau=0.45;

if (_target<_current) then {_tau=0.10};

private _k=1 - exp (-_dt / _tau);
private _value=_current+((_target-_current)*_k);

if (_value<0.02) then {_value=0.02};
if (_value>0.14) then {_value=0.14};

private _drive=missionNamespace getVariable ["ZuluFX_grainDrive",0];
private _sharpness=1.15+(0.55*_drive);
private _grainSize=1.05-(0.15*_drive);

ZuluFX_grainIntensity=_value;
ZuluFX_grainSharpness=_sharpness;
ZuluFX_grainSize=_grainSize;

ZuluFX_ppGrain ppEffectEnable true;
ZuluFX_ppGrain ppEffectAdjust [_value,_sharpness,_grainSize,0,1,1];
ZuluFX_ppGrain ppEffectCommit 0;