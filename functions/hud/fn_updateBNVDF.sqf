if (!hasInterface) exitWith {false};
disableSerialization;

private _controls=uiNamespace getVariable ["ZuluFX_bnvdfControls",[]];
private _batteryFrame=uiNamespace getVariable ["ZuluFX_bnvdfBatteryFrame",controlNull];
private _batteryBars=uiNamespace getVariable ["ZuluFX_bnvdfBatteryBars",[]];

if (
    (count _controls)!=5 ||
    {(_controls findIf {isNull _x})>=0} ||
    {isNull _batteryFrame} ||
    {(count _batteryBars)!=5} ||
    {(_batteryBars findIf {isNull _x})>=0}
) exitWith {
    [] call ZuluFX_fnc_createBNVDF;
    false
};

private _rect=uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]];

if ((count _rect)!=4) exitWith {
    {_x ctrlShow false} forEach _controls;
    _batteryFrame ctrlShow false;
    {_x ctrlShow false} forEach _batteryBars;
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
private _batteryPlaceholder=_controls#3;
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

_batteryPlaceholder ctrlShow false;

private _batteryType=toUpper (missionNamespace getVariable ["ZuluFX_nvgBatteryIndicator","NONE"]);

if (_batteryType=="HUD") then {
    private _batterySlotY=_topY+_rowGap;
    private _batterySlotH=_oh*0.060;
    private _batteryW=_ow*0.055;
    private _batteryH=_oh*0.029;
    private _batteryCenterX=_rightX+(_rightBlockW*0.78);
    private _batteryX=_batteryCenterX-(_batteryW*0.5);
    private _batteryY=_batterySlotY+((_batterySlotH-_batteryH)*0.5)-(_oh*0.012);

    _batteryFrame ctrlSetPosition [
        _batteryX,
        _batteryY,
        _batteryW,
        _batteryH
    ];
    _batteryFrame ctrlSetText "\ZuluFX\data\hud\battery_icon_ca.paa";
    _batteryFrame ctrlSetTextColor [0.81,0.96,0.93,0.95];
    _batteryFrame ctrlShow true;
    _batteryFrame ctrlCommit 0;

    private _level=missionNamespace getVariable ["ZuluFX_nvgBatteryLevel",-1];

    if (_level<0) then {
        _level=missionNamespace getVariable ["ZuluFX_batteryHUDTestLevel",1];
    };

    _level=(_level max 0) min 1;

    private _filled=if (_level<=0) then {
        0
    } else {
        ceil (_level*5)
    };

    private _innerX=_batteryX+(_batteryW*0.070);
    private _innerY=_batteryY+(_batteryH*0.255);
    private _innerW=_batteryW*0.760;
    private _innerH=_batteryH*0.490;
    private _gap=_innerW*0.035;
    private _barW=(_innerW-(4*_gap))/5;

    for "_i" from 0 to 4 do {
        private _bar=_batteryBars#_i;

        _bar ctrlSetPosition [
            _innerX+(_i*(_barW+_gap)),
            _innerY,
            _barW,
            _innerH
        ];

        _bar ctrlSetBackgroundColor [0.81,0.96,0.93,0.95];
        _bar ctrlShow (_i<_filled);
        _bar ctrlCommit 0;
    };
} else {
    _batteryFrame ctrlShow false;
    {_x ctrlShow false} forEach _batteryBars;
};

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
