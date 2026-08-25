params [["_enabled",true,[true]]];

ZuluFX_compassEnabled=_enabled;

if (!_enabled) exitWith {
    call ZuluFX_fnc_cleanupCompass;
    true
};

if !(call ZuluFX_fnc_canUseCompass) exitWith {
    call ZuluFX_fnc_cleanupCompass;
    false
};

call ZuluFX_fnc_createCompass