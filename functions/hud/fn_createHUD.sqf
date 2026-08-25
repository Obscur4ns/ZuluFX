if (!hasInterface) exitWith {false};

if !([] call ZuluFX_fnc_canUseHUD) exitWith {
    [] call ZuluFX_fnc_cleanupHUD;
    false
};

private _mode=toUpper (missionNamespace getVariable ["ZuluFX_nvgHUDMode","NONE"]);

[] call ZuluFX_fnc_cleanupHUD;

switch (_mode) do {
    case "COMPASS": {
        [] call ZuluFX_fnc_createCompass;
    };
    case "BNVDF": {
        [] call ZuluFX_fnc_createCompass;
        [] call ZuluFX_fnc_createBNVDF;
    };
    case "FPANO": {
        [] call ZuluFX_fnc_createCompass;
        [] call ZuluFX_fnc_createFPANO;
    };
};

ZuluFX_hudModeActive=_mode;
ZuluFX_hudClassActive=missionNamespace getVariable ["ZuluFX_nvgClass",""];
ZuluFX_hudDataNextUpdate=0;

[] call ZuluFX_fnc_updateHUD;

ZuluFX_hudPFH=[
    {
        [] call ZuluFX_fnc_updateHUD;
    },
    0.05
] call CBA_fnc_addPerFrameHandler;

true
