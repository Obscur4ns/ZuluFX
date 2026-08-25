if (!hasInterface) exitWith {false};
disableSerialization;

private _type=toUpper (missionNamespace getVariable ["ZuluFX_nvgBatteryIndicator","NONE"]);
private _ctrl=uiNamespace getVariable ["ZuluFX_batteryIndicatorControl",controlNull];
private _kind=uiNamespace getVariable ["ZuluFX_batteryIndicatorControlKind",""];

if (_type!="LAMP") exitWith {
    if (!isNull _ctrl) then {_ctrl ctrlShow false};
    true
};

if !(missionNamespace getVariable ["ZuluFX_nvgBatteryLow",false]) exitWith {
    if (!isNull _ctrl) then {_ctrl ctrlShow false};
    true
};

private _mode=missionNamespace getVariable ["ZuluFX_nvgTubeMode",0];
private _rect=if (_mode==4) then {
    uiNamespace getVariable ["ZuluFX_quadAperturePosition",[]]
} else {
    uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]]
};

if ((count _rect)!=4) exitWith {
    if (!isNull _ctrl) then {_ctrl ctrlShow false};
    false
};

if (_kind!="LAMP_PICTURE") then {
    if (!isNull _ctrl) then {
        ctrlDelete _ctrl;
        _ctrl=controlNull;
    };

    uiNamespace setVariable ["ZuluFX_batteryIndicatorControl",controlNull];
    uiNamespace setVariable ["ZuluFX_batteryIndicatorControlKind",""];
};

if (isNull _ctrl) then {
    private _display=findDisplay 46;
    if (isNull _display) exitWith {false};

    _ctrl=_display ctrlCreate ["RscPictureKeepAspect",-1];
    _ctrl ctrlSetText "\A3\ui_f\data\map\markers\military\dot_CA.paa";
    _ctrl ctrlSetTextColor [0.82,1,0.96,0.95];
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;

    uiNamespace setVariable ["ZuluFX_batteryIndicatorControl",_ctrl];
    uiNamespace setVariable ["ZuluFX_batteryIndicatorControlKind","LAMP_PICTURE"];
};

_rect params ["_ox","_oy","_ow","_oh"];

private _anchor=missionNamespace getVariable [
    "ZuluFX_nvgBatteryIndicatorAnchor",
    [0.195,0.155]
];

private _sizePx=16;
private _w=pixelW*_sizePx;
private _h=pixelH*_sizePx;

_ctrl ctrlSetPosition [
    _ox+(_ow*(_anchor#0))-(_w*0.5),
    _oy+(_oh*(_anchor#1))-(_h*0.5),
    _w,
    _h
];

_ctrl ctrlSetTextColor [0.82,1,0.96,0.95];
_ctrl ctrlShow true;
_ctrl ctrlCommit 0;

true
