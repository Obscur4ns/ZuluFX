if (!hasInterface) exitWith {false};

if !([] call ZuluFX_fnc_canUseHUD) exitWith {
    [] call ZuluFX_fnc_cleanupHUD;
    false
};

private _mode=toUpper (missionNamespace getVariable ["ZuluFX_nvgHUDMode","NONE"]);
private _class=missionNamespace getVariable ["ZuluFX_nvgClass",""];

if (
    _mode isNotEqualTo (missionNamespace getVariable ["ZuluFX_hudModeActive",""]) ||
    {_class isNotEqualTo (missionNamespace getVariable ["ZuluFX_hudClassActive",""])}
) exitWith {
    [] call ZuluFX_fnc_createHUD
};

private _uiSuppressed=
    !isNil "ace_arsenal_camera" ||
    {!isNull findDisplay 602} ||
    {!isNull findDisplay 312} ||
    {!isNull findDisplay 177};

if (_uiSuppressed) exitWith {
    disableSerialization;

    {
        if (!isNull _x) then {_x ctrlShow false};
    } forEach (uiNamespace getVariable ["ZuluFX_compassTicks",[]]);

    {
        if (!isNull _x) then {_x ctrlShow false};
    } forEach (uiNamespace getVariable ["ZuluFX_compassLabels",[]]);

    private _centre=uiNamespace getVariable ["ZuluFX_compassCentre",controlNull];
    private _heading=uiNamespace getVariable ["ZuluFX_compassHeading",controlNull];

    if (!isNull _centre) then {_centre ctrlShow false};
    if (!isNull _heading) then {_heading ctrlShow false};

    {
        if (!isNull _x) then {_x ctrlShow false};
    } forEach (uiNamespace getVariable ["ZuluFX_bnvdfControls",[]]);

    private _bnvdfBatteryFrame=uiNamespace getVariable ["ZuluFX_bnvdfBatteryFrame",controlNull];

    if (!isNull _bnvdfBatteryFrame) then {
        _bnvdfBatteryFrame ctrlShow false;
    };

    {
        if (!isNull _x) then {_x ctrlShow false};
    } forEach (uiNamespace getVariable ["ZuluFX_bnvdfBatteryBars",[]]);

    {
        if (!isNull _x) then {_x ctrlShow false};
    } forEach (uiNamespace getVariable ["ZuluFX_fpanoControls",[]]);

    private _battery=uiNamespace getVariable ["ZuluFX_batteryIndicatorControl",controlNull];

    if (!isNull _battery) then {
        _battery ctrlShow false;
    };

    true
};

switch (_mode) do {
    case "COMPASS": {
        [] call ZuluFX_fnc_updateCompass;
    };

    case "BNVDF": {
        [] call ZuluFX_fnc_updateCompass;
        [] call ZuluFX_fnc_updateBNVDF;
    };

    case "FPANO": {
        [] call ZuluFX_fnc_updateCompass;
        [] call ZuluFX_fnc_updateFPANO;
    };
};

[] call ZuluFX_fnc_updateBatteryIndicator;

true
