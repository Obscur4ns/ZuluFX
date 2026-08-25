params ["_enabled"];
if (ZuluFX_ppGain < 0) exitWith {};
if (!_enabled) exitWith {ZuluFX_ppGain ppEffectEnable false;};
ZuluFX_ppGain ppEffectEnable true;
ZuluFX_ppGain ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,1],[0.299,0.587,0.114,0]];
ZuluFX_ppGain ppEffectCommit 0;