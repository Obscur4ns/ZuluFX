if (!hasInterface) exitWith {false};
disableSerialization;

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {false};

private _canvas=uiNamespace getVariable ["ZuluFX_fusionCanvas",controlNull];
private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];

if (
    !isNull _canvas &&
    {!isNull _tint}
) exitWith {true};

[] call ZuluFX_fnc_cleanupFusionOverlay;

_tint=_display ctrlCreate ["RscText",-1];
_tint ctrlEnable false;
_tint ctrlSetBackgroundColor [0,0,0,0];
_tint ctrlShow false;
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

uiNamespace setVariable ["ZuluFX_fusionTint",_tint];
uiNamespace setVariable ["ZuluFX_fusionCanvas",_canvas];
uiNamespace setVariable ["ZuluFX_fusionOutlineSegments",[]];
uiNamespace setVariable ["ZuluFX_fusionCanvasReadyFrame",diag_frameNo];
uiNamespace setVariable ["ZuluFX_fusionOverlaySignature",[]];

true
