if (!hasInterface) exitWith {false};
disableSerialization;

private _controls=uiNamespace getVariable ["ZuluFX_fpanoControls",[]];
if ((count _controls)!=4 || {(_controls findIf {isNull _x})>=0}) exitWith {
    [] call ZuluFX_fnc_createFPANO;
    false
};

private _rect=uiNamespace getVariable ["ZuluFX_quadAperturePosition",[]];

if ((count _rect)!=4) exitWith {
    {_x ctrlShow false} forEach _controls;
    false
};

_rect params ["_ox","_oy","_ow","_oh"];

private _data=[] call ZuluFX_fnc_getHUDData;
private _location=_data getOrDefault ["location",""];
private _altitude=_data getOrDefault ["altitude",""];
private _time=_data getOrDefault ["time",""];
private _fusion=_data getOrDefault ["fusion",""];

private _loc=_controls#0;
private _alt=_controls#1;
private _timeCtrl=_controls#2;
private _fusionCtrl=_controls#3;

private _lineH=_oh*0.052;

_loc ctrlSetPosition [
    _ox+(_ow*0.235),
    _oy+(_oh*0.535),
    _ow*0.16,
    _lineH
];
_loc ctrlSetStructuredText parseText format [
    "<t align='center' shadow='1' font='RobotoCondensed' size='0.54' color='#CFF5EE'>%1</t>",
    _location
];
_loc ctrlShow true;
_loc ctrlCommit 0;

_alt ctrlSetPosition [
    _ox+(_ow*0.390),
    _oy+(_oh*0.585),
    _ow*0.12,
    _lineH
];
_alt ctrlSetStructuredText parseText format [
    "<t align='center' shadow='1' font='RobotoCondensed' size='0.54' color='#CFF5EE'>%1</t>",
    _altitude
];
_alt ctrlShow true;
_alt ctrlCommit 0;

_timeCtrl ctrlSetPosition [
    _ox+(_ow*0.555),
    _oy+(_oh*0.585),
    _ow*0.12,
    _lineH
];
_timeCtrl ctrlSetStructuredText parseText format [
    "<t align='center' shadow='1' font='RobotoCondensed' size='0.54' color='#CFF5EE'>%1</t>",
    _time
];
_timeCtrl ctrlShow true;
_timeCtrl ctrlCommit 0;

if (_fusion=="") then {
    _fusionCtrl ctrlShow false;
} else {
    _fusionCtrl ctrlSetPosition [
        _ox+(_ow*0.465),
        _oy+(_oh*0.585),
        _ow*0.14,
        _lineH
    ];
    _fusionCtrl ctrlSetStructuredText parseText format [
        "<t align='center' shadow='1' font='RobotoCondensed' size='0.56' color='#CFF5EE'>%1</t>",
        _fusion
    ];
    _fusionCtrl ctrlShow true;
    _fusionCtrl ctrlCommit 0;
};

true
