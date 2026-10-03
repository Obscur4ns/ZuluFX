if (!hasInterface) exitWith {false};

if !(call ZuluFX_fnc_canUseCompass) exitWith {
    call ZuluFX_fnc_cleanupCompass;
    false
};

disableSerialization;

private _ticks=uiNamespace getVariable ["ZuluFX_compassTicks",[]];
private _bearings=uiNamespace getVariable ["ZuluFX_compassLabels",[]];
private _directions=uiNamespace getVariable ["ZuluFX_compassDirections",[]];
private _centre=uiNamespace getVariable ["ZuluFX_compassCentre",controlNull];
private _headingCtrl=uiNamespace getVariable ["ZuluFX_compassHeading",controlNull];

if (
    (count _ticks)!=15 ||
    {(count _bearings)!=15} ||
    {(count _directions)!=15} ||
    {isNull _centre} ||
    {isNull _headingCtrl}
) exitWith {
    call ZuluFX_fnc_createCompass;
    false
};

private _mode=missionNamespace getVariable ["ZuluFX_nvgTubeMode",0];

private _rect=switch (_mode) do {
    case 2: {uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]]};
    case 4: {uiNamespace getVariable ["ZuluFX_quadAperturePosition",[]]};
    default {[]};
};

if ((count _rect)!=4) exitWith {
    {_x ctrlShow false} forEach _ticks;
    {_x ctrlShow false} forEach _bearings;
    {_x ctrlShow false} forEach _directions;
    _centre ctrlShow false;
    _headingCtrl ctrlShow false;
    false
};

_rect params ["_ox","_oy","_ow","_oh"];

private _anchor=missionNamespace getVariable ["ZuluFX_nvgCompassAnchor",[0.5,0.18]];
private _tapeWidthFrac=missionNamespace getVariable ["ZuluFX_compassTapeWidth",0.27];
private _tapeHeightFrac=missionNamespace getVariable ["ZuluFX_compassTapeHeight",0.080];
private _halfSpan=missionNamespace getVariable ["ZuluFX_compassHalfSpan",30];

private _tapeW=_ow*_tapeWidthFrac;
private _tapeH=_oh*_tapeHeightFrac;

private _centreX=_ox+(_ow*(_anchor#0));
private _centreY=_oy+(_oh*(_anchor#1));

private _tapeY=_centreY-(_tapeH*0.5);
private _datumY=_tapeY+(_tapeH*0.50);

private _view=getCameraViewDirection player;
private _heading=(_view#0) atan2 (_view#1);
if (_heading<0) then {_heading=_heading+360};

private _step=5;
private _middle=7;
private _base=floor (_heading/_step)*_step;

private _directionFor={
    params ["_value"];
    switch (_value) do {
        case 0: {"N"};
        case 45: {"NE"};
        case 90: {"E"};
        case 135: {"SE"};
        case 180: {"S"};
        case 225: {"SW"};
        case 270: {"W"};
        case 315: {"NW"};
        default {""};
    };
};

for "_i" from 0 to 14 do {
    private _tick=_ticks#_i;
    private _bearingCtrl=_bearings#_i;
    private _directionCtrl=_directions#_i;

    private _raw=_base+((_i-_middle)*_step);
    private _value=_raw mod 360;
    if (_value<0) then {_value=_value+360};

    private _delta=_raw-_heading;
    if (_delta>180) then {_delta=_delta-360};
    if (_delta<-180) then {_delta=_delta+360};

    private _visible=abs _delta<=_halfSpan;

    if (!_visible) then {
        _tick ctrlShow false;
        _bearingCtrl ctrlShow false;
        _directionCtrl ctrlShow false;
    } else {
        private _x=_centreX+((_delta/_halfSpan)*(_tapeW*0.5));
        private _direction=[_value] call _directionFor;
        private _bearingTick=(_value mod 10)==0;
        private _directionTick=_direction!="";

        private _tickW=_ow*0.00125;
        private _tickH=if (_directionTick) then {
            _tapeH*0.28
        } else {
            if (_bearingTick) then {_tapeH*0.23} else {_tapeH*0.14}
        };

        _tick ctrlSetPosition [
            _x-(_tickW*0.5),
            _datumY-(_tickH*0.5),
            _tickW,
            _tickH
        ];

        _tick ctrlSetBackgroundColor [
            1,1,1,
            if (_directionTick) then {0.96} else {
                if (_bearingTick) then {0.88} else {0.62}
            }
        ];

        _tick ctrlShow true;
        _tick ctrlCommit 0;

        if (_directionTick) then {
            private _directionW=_ow*0.052;
            private _directionH=_tapeH*0.26;

            _directionCtrl ctrlSetPosition [
                _x-(_directionW*0.5),
                _datumY-(_tapeH*0.57),
                _directionW,
                _directionH
            ];

            _directionCtrl ctrlSetStructuredText parseText format [
                "<t align='center' shadow='1' font='RobotoCondensed' size='0.52' color='#FFFFFF'>%1</t>",
                _direction
            ];

            _directionCtrl ctrlShow true;
            _directionCtrl ctrlCommit 0;
        } else {
            _directionCtrl ctrlShow false;
        };

        if (_bearingTick || {_directionTick}) then {
            private _digits=str (round _value);
            if (_value<100) then {_digits="0"+_digits};
            if (_value<10) then {_digits="0"+_digits};

            private _bearingW=_ow*0.052;
            private _bearingH=_tapeH*0.26;

            _bearingCtrl ctrlSetPosition [
                _x-(_bearingW*0.5),
                _datumY+(_tapeH*0.17),
                _bearingW,
                _bearingH
            ];

            _bearingCtrl ctrlSetStructuredText parseText format [
                "<t align='center' shadow='1' font='RobotoCondensed' size='0.44' color='#FFFFFF'>%1</t>",
                _digits
            ];

            _bearingCtrl ctrlShow true;
            _bearingCtrl ctrlCommit 0;
        } else {
            _bearingCtrl ctrlShow false;
        };
    };
};

private _centreW=_ow*0.00155;
private _centreH=_tapeH*0.34;

_centre ctrlSetPosition [
    _centreX-(_centreW*0.5),
    _datumY-(_centreH*0.5),
    _centreW,
    _centreH
];

_centre ctrlSetBackgroundColor [1,1,1,1];
_centre ctrlShow true;
_centre ctrlCommit 0;

_headingCtrl ctrlShow false;

true
