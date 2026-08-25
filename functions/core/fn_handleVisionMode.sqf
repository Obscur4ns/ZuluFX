params ["_unit","_visionMode"];

if (_unit isNotEqualTo player) exitWith {};

private _active=_visionMode==1;
private _phosphor=missionNamespace getVariable ["ZuluFX_phosphorProfile",missionNamespace getVariable ["ZuluFX_settingPhosphor","P45"]];
private _filter=missionNamespace getVariable ["ZuluFX_outputFilter",missionNamespace getVariable ["ZuluFX_settingOutputFilter","NONE"]];

ZuluFX_nvgActive=_active;

[_active] call ZuluFX_fnc_setGrain;
[_active] call ZuluFX_fnc_setGain;
[_active,_phosphor] call ZuluFX_fnc_setPhosphor;
[_active,_filter] call ZuluFX_fnc_setOutputFilter;

if (_active) exitWith {
    uiNamespace setVariable ["ZuluFX_binoRenderSignature",[]];
    uiNamespace setVariable ["ZuluFX_quadRenderSignature",[]];
    ZuluFX_scintillationNextUpdate=0;
    true
};

if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
    [] call ZuluFX_fnc_cleanupFusion;
};

[] call ZuluFX_fnc_cleanupScintillation;

disableSerialization;

private _binoMask=uiNamespace getVariable ["ZuluFX_binoOverlayPicture",controlNull];
if (!isNull _binoMask) then {ctrlDelete _binoMask};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach (uiNamespace getVariable ["ZuluFX_binoOverlayEdges",[]]);

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach (uiNamespace getVariable ["ZuluFX_binoGatePictures",[]]);

private _quadMask=uiNamespace getVariable ["ZuluFX_quadOverlayPicture",controlNull];
if (!isNull _quadMask) then {ctrlDelete _quadMask};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach (uiNamespace getVariable ["ZuluFX_quadOverlayEdges",[]]);

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach (uiNamespace getVariable ["ZuluFX_quadGatePictures",[]]);

uiNamespace setVariable ["ZuluFX_binoOverlayPicture",controlNull];
uiNamespace setVariable ["ZuluFX_binoOverlayEdges",[]];
uiNamespace setVariable ["ZuluFX_binoGatePictures",[]];
uiNamespace setVariable ["ZuluFX_binoGatePosition",[]];
uiNamespace setVariable ["ZuluFX_binoAperturePosition",[]];
uiNamespace setVariable ["ZuluFX_binoGateAlpha",[-1,-1]];
uiNamespace setVariable ["ZuluFX_binoRenderSignature",[]];

uiNamespace setVariable ["ZuluFX_quadOverlayPicture",controlNull];
uiNamespace setVariable ["ZuluFX_quadOverlayEdges",[]];
uiNamespace setVariable ["ZuluFX_quadPosition",[]];
uiNamespace setVariable ["ZuluFX_quadAperturePosition",[]];
uiNamespace setVariable ["ZuluFX_quadRenderSignature",[]];
uiNamespace setVariable ["ZuluFX_quadGatePictures",[]];
uiNamespace setVariable ["ZuluFX_quadGatePosition",[]];
uiNamespace setVariable ["ZuluFX_quadGateAlpha",[-1,-1,-1,-1]];
uiNamespace setVariable ["ZuluFX_quadGateProfile",-1];

ZuluFX_gateLeft=0;
ZuluFX_gateRight=0;
ZuluFX_gateLeftTarget=0;
ZuluFX_gateRightTarget=0;
ZuluFX_gateLeftResidual=0;
ZuluFX_gateRightResidual=0;

ZuluFX_quadGates=[0,0,0,0];
ZuluFX_quadResiduals=[0,0,0,0];

true
