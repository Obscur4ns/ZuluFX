if (!hasInterface) exitWith {false};

if !(missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {false};
if ((toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]))!="PATROL") exitWith {false};

if (!isPiPEnabled) exitWith {
    ZuluFX_fusionThermalReady=false;
    false
};

private _camera=missionNamespace getVariable ["ZuluFX_fusionThermalCamera",objNull];
private _control=uiNamespace getVariable ["ZuluFX_fusionThermalControl",controlNull];

if (!isNull _camera && {!isNull _control}) exitWith {
    ZuluFX_fusionThermalReady=true;
    true
};

[] call ZuluFX_fnc_cleanupFusionThermal;

private _display=findDisplay 46;
if (isNull _display) exitWith {
    ZuluFX_fusionThermalReady=false;
    false
};

private _viewPos=positionCameraToWorld [0,0,0];
_camera="camera" camCreate _viewPos;

if (isNull _camera) exitWith {
    ZuluFX_fusionThermalReady=false;
    false
};

_camera cameraEffect ["Internal","Back","zulufx_ecoti_ti"];
"zulufx_ecoti_ti" setPiPEffect [2];

private _fov=(missionNamespace getVariable ["ZuluFX_nvgFusionFOV",30]) max 1 min 120;
_camera camSetFov (tan (_fov*0.5));
_camera camCommit 0;

disableSerialization;
_control=_display ctrlCreate ["RscPicture",-1];

private _aspect=(missionNamespace getVariable ["ZuluFX_nvgFusionAspect",4/3]) max 0.5 min 2;
private _texture=format ["#(argb,512,512,1)r2t(zulufx_ecoti_ti,%1)",_aspect];

_control ctrlSetText _texture;
_control ctrlSetTextColor [1,1,1,1];
_control ctrlEnable false;
_control ctrlShow false;
_control ctrlCommit 0;

ZuluFX_fusionThermalCamera=_camera;
ZuluFX_fusionThermalReady=true;
ZuluFX_fusionThermalFOVActive=_fov;
uiNamespace setVariable ["ZuluFX_fusionThermalControl",_control];
uiNamespace setVariable ["ZuluFX_fusionThermalWindow",[]];

true
