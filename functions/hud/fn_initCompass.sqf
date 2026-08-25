if (!hasInterface) exitWith {};

ZuluFX_compassEnabled=true;

["visionMode",{
    params ["_unit","_newMode"];

    if (_newMode==1) then {
        [true] call ZuluFX_fnc_setCompass;
    } else {
        call ZuluFX_fnc_cleanupCompass;
    };
},true] call CBA_fnc_addPlayerEventHandler;

["loadout",{
    [false,false] call ZuluFX_fnc_updateNVGProfile;

    if (call ZuluFX_fnc_canUseCompass) then {
        [true] call ZuluFX_fnc_setCompass;
    } else {
        call ZuluFX_fnc_cleanupCompass;
    };
}] call CBA_fnc_addPlayerEventHandler;