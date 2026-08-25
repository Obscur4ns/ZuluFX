if (!hasInterface) exitWith {false};
disableSerialization;

private _controls=uiNamespace getVariable ["ZuluFX_bnvdfControls",[]];
if ((count _controls)!=5 || {(_controls findIf {isNull _x})>=0}) exitWith {
    [] call ZuluFX_fnc_createBNVDF;
    false
};

private _rect=uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]];
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
private _battery=_controls#3;
private _fusionCtrl=_controls#4;

private _lineH=_oh*0.060;
private _leftBlockW=_ow*0.24;
private _rightBlockW=_ow*0.22;
private _leftX=_ox+(_ow*0.09);
private _rightX=_ox+(_ow*0.70);
private _topY=_oy+(_oh*0.315);
private _rowGap=_oh*0.047;

_loc ctrlSetPosition [_leftX,_topY,_leftBlockW,_lineH];
_loc ctrlSetStructuredText parseText format [
    "<t align='left' shadow='1' font='RobotoCondensed' size='0.70' color='#CFF5EE'>LOC %1</t>",
    _location
];
_loc ctrlShow true;
_loc ctrlCommit 0;

_alt ctrlSetPosition [_leftX,_topY+_rowGap,_leftBlockW,_lineH];
_alt ctrlSetStructuredText parseText format [
    "<t align='left' shadow='1' font='RobotoCondensed' size='0.70' color='#CFF5EE'>ALT %1</t>",
    _altitude
];
_alt ctrlShow true;
_alt ctrlCommit 0;

_timeCtrl ctrlSetPosition [_rightX,_topY,_rightBlockW,_lineH];
_timeCtrl ctrlSetStructuredText parseText format [
    "<t align='right' shadow='1' font='RobotoCondensed' size='0.70' color='#CFF5EE'>TIME %1</t>",
    _time
];
_timeCtrl ctrlShow true;
_timeCtrl ctrlCommit 0;

_battery ctrlSetPosition [_rightX,_topY+_rowGap,_rightBlockW,_lineH];
_battery ctrlShow false;
_battery ctrlCommit 0;

if (_fusion=="") then {
    _fusionCtrl ctrlShow false;
} else {
    private _fusionW=_ow*0.20;
    _fusionCtrl ctrlSetPosition [
        _ox+(_ow*0.5)-(_fusionW*0.5),
        _oy+(_oh*0.80),
        _fusionW,
        _oh*0.065
    ];
    _fusionCtrl ctrlSetStructuredText parseText format [
        "<t align='center' shadow='1' font='RobotoCondensed' size='0.70' color='#CFF5EE'>%1</t>",
        _fusion
    ];
    _fusionCtrl ctrlShow true;
    _fusionCtrl ctrlCommit 0;
};

true
