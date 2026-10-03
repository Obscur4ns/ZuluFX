if (!hasInterface) exitWith {false};

disableSerialization;

private _control=uiNamespace getVariable ["ZuluFX_fusionThermalControl",controlNull];
if (!isNull _control) then {
    ctrlDelete _control;
};

private _camera=missionNamespace getVariable ["ZuluFX_fusionThermalCamera",objNull];
if (!isNull _camera) then {
    _camera cameraEffect ["terminate","back","zulufx_ecoti_ti"];
    camDestroy _camera;
};

ZuluFX_fusionThermalCamera=objNull;
ZuluFX_fusionThermalReady=false;
ZuluFX_fusionThermalFOVActive=-1;

uiNamespace setVariable ["ZuluFX_fusionThermalControl",controlNull];
uiNamespace setVariable ["ZuluFX_fusionThermalWindow",[]];

true
