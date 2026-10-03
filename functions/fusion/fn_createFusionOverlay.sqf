if (!hasInterface) exitWith {false};
disableSerialization;

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {false};

private _canvas=uiNamespace getVariable ["ZuluFX_fusionCanvas",controlNull];
private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];
private _frame=uiNamespace getVariable ["ZuluFX_fusionFrame",[]];

if (
    !isNull _canvas &&
    {!isNull _tint} &&
    {(count _frame)==4} &&
    {(_frame findIf {isNull _x})<0}
) exitWith {true};

[] call ZuluFX_fnc_cleanupFusionOverlay;

_tint=_display ctrlCreate ["RscText",-1];
_tint ctrlEnable false;
private _tintColor=missionNamespace getVariable ["ZuluFX_fusionWindowTint",[0.64,0.31,0.18,0.025]];
private _frameColor=missionNamespace getVariable ["ZuluFX_fusionWindowColor",[1.00,0.41,0.10,0.78]];
_tint ctrlSetBackgroundColor _tintColor;
_tint ctrlCommit 0;

_canvas=_display ctrlCreate ["ZuluFX_RscFusionMap",-1];
_canvas ctrlSetPosition [safeZoneXAbs,safeZoneY,safeZoneWAbs,safeZoneH];
_canvas ctrlSetFade 1;
_canvas ctrlEnable false;
_canvas ctrlCommit 0;
_canvas ctrlMapAnimAdd [0,0.0001,[5,5,0]];
ctrlMapAnimCommit _canvas;
_canvas ctrlAddEventHandler ["Draw",{
    params ["_map"];
    {
        _map drawLine _x;
    } forEach (uiNamespace getVariable ["ZuluFX_fusionOutlineSegments",[]]);
}];

_frame=[];
for "_i" from 0 to 3 do {
    private _ctrl=_display ctrlCreate ["RscText",-1];
    _ctrl ctrlEnable false;
    _ctrl ctrlSetBackgroundColor _frameColor;
    _ctrl ctrlCommit 0;
    _frame pushBack _ctrl;
};

uiNamespace setVariable ["ZuluFX_fusionTint",_tint];
uiNamespace setVariable ["ZuluFX_fusionCanvas",_canvas];
uiNamespace setVariable ["ZuluFX_fusionFrame",_frame];
uiNamespace setVariable ["ZuluFX_fusionOutlineSegments",[]];
uiNamespace setVariable ["ZuluFX_fusionCanvasReadyFrame",diag_frameNo];
uiNamespace setVariable ["ZuluFX_fusionOverlaySignature",[]];

true