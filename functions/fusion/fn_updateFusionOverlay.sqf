if (!hasInterface) exitWith {false};

if !(missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {
    [] call ZuluFX_fnc_cleanupFusionOverlay;
    false
};

private _uiSuppressed=
    !isNil "ace_arsenal_camera" ||
    {!isNull findDisplay 602} ||
    {!isNull findDisplay 312} ||
    {!isNull findDisplay 177};

if (_uiSuppressed) exitWith {
    ["clear"] call ZuluFX_fnc_fusionCanvas;

    disableSerialization;

    private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];

    if (!isNull _tint) then {
        _tint ctrlShow false;
    };

    true
};

if !([] call ZuluFX_fnc_createFusionOverlay) exitWith {false};

disableSerialization;

private _window=[] call ZuluFX_fnc_getFusionWindow;
if ((count _window)!=4) exitWith {false};

private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);
private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];

if (isNull _tint) exitWith {false};

private _patrolTint=missionNamespace getVariable [
    "ZuluFX_fusionPatrolWindowTint",
    [0.10,0.10,0.10,0.075]
];

private _outlineTint=missionNamespace getVariable [
    "ZuluFX_fusionOutlineWindowTint",
    [0.64,0.31,0.18,0.075]
];

private _tintColor=if (_mode=="OUTLINE") then {
    _outlineTint
} else {
    _patrolTint
};

private _signature=[
    _window,
    _mode,
    _tintColor
];

private _old=uiNamespace getVariable [
    "ZuluFX_fusionOverlaySignature",
    []
];

if !(_signature isEqualTo _old) then {
    _tint ctrlSetPosition _window;
    _tint ctrlSetBackgroundColor _tintColor;
    _tint ctrlCommit 0;

    uiNamespace setVariable [
        "ZuluFX_fusionOverlaySignature",
        _signature
    ];
};

_tint ctrlShow true;

if (_mode=="OUTLINE") then {
    [] call ZuluFX_fnc_drawFusionOutlines;
} else {
    ["clear"] call ZuluFX_fnc_fusionCanvas;
};

true
