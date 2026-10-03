if (!hasInterface) exitWith {false};
disableSerialization;

private _tint=uiNamespace getVariable ["ZuluFX_fusionTint",controlNull];
private _canvas=uiNamespace getVariable ["ZuluFX_fusionCanvas",controlNull];
private _frame=uiNamespace getVariable ["ZuluFX_fusionFrame",[]];

if (!isNull _tint) then {ctrlDelete _tint};
if (!isNull _canvas) then {ctrlDelete _canvas};
{if (!isNull _x) then {ctrlDelete _x}} forEach _frame;

uiNamespace setVariable ["ZuluFX_fusionTint",controlNull];
uiNamespace setVariable ["ZuluFX_fusionCanvas",controlNull];
uiNamespace setVariable ["ZuluFX_fusionFrame",[]];
uiNamespace setVariable ["ZuluFX_fusionOutlineSegments",[]];
uiNamespace setVariable ["ZuluFX_fusionOverlaySignature",[]];

true