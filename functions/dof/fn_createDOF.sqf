if (!hasInterface) exitWith {-1};
if (!isNil "ZuluFX_ppDOF" && {ZuluFX_ppDOF>=0}) exitWith {ZuluFX_ppDOF};

private _priority=2200;
ZuluFX_ppDOF=-1;

while {ZuluFX_ppDOF<0} do {
    ZuluFX_ppDOF=ppEffectCreate ["DepthOfField",_priority];
    _priority=_priority+1;
};

ZuluFX_ppDOF ppEffectForceInNVG true;
ZuluFX_ppDOF ppEffectEnable false;

ZuluFX_ppDOF