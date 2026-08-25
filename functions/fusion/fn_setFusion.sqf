params [["_active",false,[true]]];

if (!hasInterface || {isNull player}) exitWith {false};

if (_active) exitWith {
    if !([] call ZuluFX_fnc_canUseFusion) exitWith {
        [] call ZuluFX_fnc_cleanupFusion;
        false
    };

    [] call ZuluFX_fnc_createFusion
};

[] call ZuluFX_fnc_cleanupFusion
