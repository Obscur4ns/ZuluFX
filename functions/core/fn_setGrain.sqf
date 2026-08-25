params [["_enabled",true,[true]]];

if (ZuluFX_ppGrain<0) exitWith {};

if (!_enabled || {missionNamespace getVariable ["ZuluFX_debugVisualBypass",false]}) exitWith {
    ZuluFX_ppGrain ppEffectEnable false;
};

private _value=missionNamespace getVariable ["ZuluFX_grainIntensity",0.05];
private _drive=missionNamespace getVariable ["ZuluFX_grainDrive",0.25];
private _sharpness=1.15+(0.55*_drive);
private _grainSize=1.05-(0.15*_drive);

ZuluFX_ppGrain ppEffectEnable true;
ZuluFX_ppGrain ppEffectAdjust [_value,_sharpness,_grainSize,0,1,1];
ZuluFX_ppGrain ppEffectCommit 0;