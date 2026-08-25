if (!hasInterface) exitWith {};
private _priority=2100;
if (isNil "ZuluFX_ppGrain" || {ZuluFX_ppGrain<0}) then {
    ZuluFX_ppGrain=-1;
    while {ZuluFX_ppGrain<0} do {ZuluFX_ppGrain=ppEffectCreate ["FilmGrain",_priority];_priority=_priority+1;};
    ZuluFX_ppGrain ppEffectEnable false;
};
ZuluFX_ppGrain ppEffectForceInNVG true;
if (isNil "ZuluFX_ppGain" || {ZuluFX_ppGain<0}) then {
    ZuluFX_ppGain=-1;
    while {ZuluFX_ppGain<0} do {ZuluFX_ppGain=ppEffectCreate ["ColorCorrections",_priority];_priority=_priority+1;};
    ZuluFX_ppGain ppEffectEnable false;
};
ZuluFX_ppGain ppEffectForceInNVG true;