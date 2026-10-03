if (!hasInterface) exitWith {false};
disableSerialization;

private _tint=uiNamespace getVariable [
    "ZuluFX_fusionTint",
    controlNull
];

private _canvas=uiNamespace getVariable [
    "ZuluFX_fusionCanvas",
    controlNull
];

if (!isNull _tint) then {
    ctrlDelete _tint;
};

if (!isNull _canvas) then {
    ctrlDelete _canvas;
};

uiNamespace setVariable [
    "ZuluFX_fusionTint",
    controlNull
];

uiNamespace setVariable [
    "ZuluFX_fusionCanvas",
    controlNull
];

uiNamespace setVariable [
    "ZuluFX_fusionOutlineSegments",
    []
];

uiNamespace setVariable [
    "ZuluFX_fusionOverlaySignature",
    []
];

true
