if (!hasInterface) exitWith {};
if (!isNil "ZuluFX_environmentPFH") exitWith {};
call ZuluFX_fnc_updateEnvironment;
ZuluFX_environmentPFH = [{call ZuluFX_fnc_updateEnvironment},0.5] call CBA_fnc_addPerFrameHandler;