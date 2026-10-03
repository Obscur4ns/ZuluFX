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
    private _frame=uiNamespace getVariable ["ZuluFX_fusionFrame",[]];

    if (!isNull _tint) then {_tint ctrlShow false};
    {if (!isNull _x) then {_x ctrlShow false}} forEach _frame;
    true
};

if !([] call ZuluFX_fnc_createFusionOverlay) exitWith {false};

disableSerialization;

private _window=[] call ZuluFX_fnc_getFusionWindow;
if ((count _window)!=4) exitWith {false};
_window params ["_x","_y","_w","_h"];

private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);
private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];
private _frame=uiNamespace getVariable ["ZuluFX_fusionFrame",[]];

private _linePx=(missionNamespace getVariable ["ZuluFX_fusionWindowLinePx",2]) max 1 min 6;
private _vx=_linePx*pixelW;
private _hy=_linePx*pixelH;

private _patrolTint=missionNamespace getVariable [
    "ZuluFX_fusionPatrolWindowTint",
    [0.10,0.10,0.10,0.075]
];

private _outlineTint=missionNamespace getVariable [
    "ZuluFX_fusionOutlineWindowTint",
    [0.64,0.31,0.18,0.10]
];

private _outlineFrame=missionNamespace getVariable [
    "ZuluFX_fusionWindowColor",
    [1.00,0.41,0.10,0.86]
];

private _tintColor=if (_mode=="OUTLINE") then {_outlineTint} else {_patrolTint};
private _frameColor=if (_mode=="OUTLINE") then {_outlineFrame} else {[0,0,0,0]};

private _signature=[_window,_vx,_hy,_mode,_tintColor,_frameColor];
private _old=uiNamespace getVariable ["ZuluFX_fusionOverlaySignature",[]];

if !(_signature isEqualTo _old) then {
    _tint ctrlSetPosition _window;
    _tint ctrlSetBackgroundColor _tintColor;
    _tint ctrlCommit 0;

    private _positions=[
        [_x,_y,_w,_hy],
        [_x,_y+_h-_hy,_w,_hy],
        [_x,_y,_vx,_h],
        [_x+_w-_vx,_y,_vx,_h]
    ];

    for "_i" from 0 to 3 do {
        private _ctrl=_frame#_i;
        _ctrl ctrlSetPosition (_positions#_i);
        _ctrl ctrlSetBackgroundColor _frameColor;
        _ctrl ctrlCommit 0;
    };

    uiNamespace setVariable ["ZuluFX_fusionOverlaySignature",_signature];
};

_tint ctrlShow true;

if (_mode=="OUTLINE") then {
    {_x ctrlShow true} forEach _frame;
    [] call ZuluFX_fnc_drawFusionOutlines;
} else {
    {_x ctrlShow false} forEach _frame;
    ["clear"] call ZuluFX_fnc_fusionCanvas;
};

true
