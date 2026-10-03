if (!hasInterface) exitWith {false};

private _active=missionNamespace getVariable ["ZuluFX_fusionActive",false];
private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);

if (!_active || {_mode!="PATROL"}) exitWith {
    disableSerialization;
    private _ctrl=uiNamespace getVariable ["ZuluFX_fusionThermalControl",controlNull];
    if (!isNull _ctrl) then {_ctrl ctrlShow false};
    false
};

if !([] call ZuluFX_fnc_createFusionThermal) exitWith {false};

private _camera=missionNamespace getVariable ["ZuluFX_fusionThermalCamera",objNull];
private _control=uiNamespace getVariable ["ZuluFX_fusionThermalControl",controlNull];

if (isNull _camera || {isNull _control}) exitWith {false};

private _window=[] call ZuluFX_fnc_getFusionWindow;
if ((count _window)!=4) exitWith {false};

private _oldWindow=uiNamespace getVariable ["ZuluFX_fusionThermalWindow",[]];

if !(_window isEqualTo _oldWindow) then {
    _control ctrlSetPosition _window;
    _control ctrlCommit 0;
    uiNamespace setVariable ["ZuluFX_fusionThermalWindow",_window];
};

private _fov=(missionNamespace getVariable ["ZuluFX_nvgFusionFOV",30]) max 1 min 120;
private _oldFov=missionNamespace getVariable ["ZuluFX_fusionThermalFOVActive",-1];

if (_fov!=_oldFov) then {
    _camera camSetFov (tan (_fov*0.5));
    _camera camCommit 0;
    ZuluFX_fusionThermalFOVActive=_fov;
};

private _viewPos=positionCameraToWorld [0,0,0];
private _viewDir=getCameraViewDirection player;

if ((vectorMagnitude _viewDir)<=0.001) then {
    private _forwardPos=positionCameraToWorld [0,0,1];
    _viewDir=_viewPos vectorFromTo _forwardPos;
};

private _upPos=positionCameraToWorld [0,1,0];
private _viewUp=_viewPos vectorFromTo _upPos;

private _right=_viewDir vectorCrossProduct _viewUp;
private _rightMag=vectorMagnitude _right;

if (_rightMag>0.001) then {
    _right=_right vectorMultiply (1/_rightMag);
    _viewUp=_right vectorCrossProduct _viewDir;
};

private _offset=(missionNamespace getVariable ["ZuluFX_fusionThermalCameraOffset",0]) max 0 min 0.15;
private _anchorPos=_viewPos vectorAdd (_viewDir vectorMultiply _offset);

_camera setPos _anchorPos;
_camera setVectorDirAndUp [_viewDir,_viewUp];

_control ctrlShow true;
true
