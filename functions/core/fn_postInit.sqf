if (!hasInterface) exitWith {};
call ZuluFX_fnc_createEffects;
["visionMode",{_this call ZuluFX_fnc_handleVisionMode},true] call CBA_fnc_addPlayerEventHandler;
call ZuluFX_fnc_startEnvironmentLoop;
call ZuluFX_fnc_startGrainLoop;
call ZuluFX_fnc_startGainLoop;
call ZuluFX_fnc_startGatingLoop;
ZuluFX_initialized = true;