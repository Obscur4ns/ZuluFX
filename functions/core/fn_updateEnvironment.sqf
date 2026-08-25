if (!hasInterface || {isNull player}) exitWith {};
private _lighting = call ZuluFX_fnc_getLighting;
ZuluFX_ambientBrightness = _lighting select 0;
ZuluFX_dynamicBrightness = _lighting select 1;
ZuluFX_skyExposure = call ZuluFX_fnc_getSkyExposure;