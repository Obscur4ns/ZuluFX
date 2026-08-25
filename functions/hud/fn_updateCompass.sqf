if (!hasInterface) exitWith {false};

if !(call ZuluFX_fnc_canUseCompass) exitWith {
    call ZuluFX_fnc_cleanupCompass;
    false
};

disableSerialization;

private _ticks=uiNamespace getVariable ["ZuluFX_compassTicks",[]];
private _labels=uiNamespace getVariable ["ZuluFX_compassLabels",[]];
private _centre=uiNamespace getVariable ["ZuluFX_compassCentre",controlNull];
private _headingCtrl=uiNamespace getVariable ["ZuluFX_compassHeading",controlNull];

if (
    (count _ticks)!=15 ||
    {(count _labels)!=15} ||
    {isNull _centre} ||
    {isNull _headingCtrl}
) exitWith {
    call ZuluFX_fnc_createCompass;
    false
};

private _mode=missionNamespace getVariable ["ZuluFX_nvgTubeMode",0];

private _rect=switch (_mode) do {
    case 2: {
        uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]]
    };
    case 4: {
        uiNamespace getVariable ["ZuluFX_quadAperturePosition",[]]
    };
    default {
        []
    };
};

if ((count _rect)!=4) exitWith {
    {_x ctrlShow false} forEach _ticks;
    {_x ctrlShow false} forEach _labels;
    _centre ctrlShow false;
    _headingCtrl ctrlShow false;
    false
};

_rect params ["_ox","_oy","_ow","_oh"];

private _anchor=missionNamespace getVariable [
    "ZuluFX_nvgCompassAnchor",
    [0.5,0.18]
];

private _tapeWidthFrac=missionNamespace getVariable [
    "ZuluFX_compassTapeWidth",
    0.27
];

private _tapeHeightFrac=missionNamespace getVariable [
    "ZuluFX_compassTapeHeight",
    0.075
];

private _halfSpan=missionNamespace getVariable [
    "ZuluFX_compassHalfSpan",
    30
];

private _tapeW=_ow*_tapeWidthFrac;
private _tapeH=_oh*_tapeHeightFrac;

private _centreX=_ox+(_ow*(_anchor#0));
private _centreY=_oy+(_oh*(_anchor#1));

private _tapeX=_centreX-(_tapeW*0.5);
private _tapeY=_centreY-(_tapeH*0.5);

private _view=getCameraViewDirection player;
private _heading=(_view#0) atan2 (_view#1);

if (_heading<0) then {
    _heading=_heading+360;
};

private _headingRounded=round _heading;

if (_headingRounded>=360) then {
    _headingRounded=0;
};

private _step=5;
private _middle=7;
private _base=floor (_heading/_step)*_step;

for "_i" from 0 to 14 do {
    private _tick=_ticks#_i;
    private _label=_labels#_i;

    private _raw=_base+((_i-_middle)*_step);
    private _value=_raw mod 360;

    if (_value<0) then {
        _value=_value+360;
    };

    private _delta=_raw-_heading;

    if (_delta>180) then {
        _delta=_delta-360;
    };

    if (_delta<-180) then {
        _delta=_delta+360;
    };

    private _visible=abs _delta<=_halfSpan;

    if (!_visible) then {
        _tick ctrlShow false;
        _label ctrlShow false;
    } else {
        private _x=_centreX+((_delta/_halfSpan)*(_tapeW*0.5));
        private _major=(_value mod 10)==0;

        private _tickW=_ow*0.0014;
        private _tickH=if (_major) then {
            _tapeH*0.28
        } else {
            _tapeH*0.16
        };

        private _tickY=_tapeY+(_tapeH*0.45);

        _tick ctrlSetPosition [
            _x-(_tickW*0.5),
            _tickY,
            _tickW,
            _tickH
        ];

        _tick ctrlSetBackgroundColor [
            0.78,
            0.95,
            0.92,
            if (_major) then {0.90} else {0.68}
        ];

        _tick ctrlShow true;
        _tick ctrlCommit 0;

        if (_major) then {
            private _text=switch (_value) do {
                case 0: {"N"};
                case 90: {"E"};
                case 180: {"S"};
                case 270: {"W"};
                default {
                    private _n=round (_value/10);
                    private _s=str _n;

                    if (_n<10) then {
                        _s="0"+_s;
                    };

                    _s
                };
            };

            private _labelW=_ow*0.050;
            private _labelH=_tapeH*0.40;

            _label ctrlSetPosition [
                _x-(_labelW*0.5),
                _tapeY,
                _labelW,
                _labelH
            ];

            _label ctrlSetStructuredText parseText format [
                "<t align='center' shadow='1' font='RobotoCondensed' size='0.60' color='#CFF5EE'>%1</t>",
                _text
            ];

            _label ctrlShow true;
            _label ctrlCommit 0;
        } else {
            _label ctrlShow false;
        };
    };
};

private _centreW=_ow*0.0022;
private _centreH=_tapeH*0.19;

_centre ctrlSetPosition [
    _centreX-(_centreW*0.5),
    _tapeY+(_tapeH*0.72),
    _centreW,
    _centreH
];

_centre ctrlSetBackgroundColor [0.82,1,0.96,1];
_centre ctrlShow true;
_centre ctrlCommit 0;

private _digits=str _headingRounded;

if (_headingRounded<100) then {
    _digits="0"+_digits;
};

if (_headingRounded<10) then {
    _digits="0"+_digits;
};

private _headingW=_ow*0.075;
private _headingH=_oh*0.025;

_headingCtrl ctrlSetPosition [
    _centreX-(_headingW*0.5),
    _tapeY+(_tapeH*0.91),
    _headingW,
    _headingH
];

_headingCtrl ctrlSetStructuredText parseText format [
    "<t align='center' shadow='1' font='RobotoCondensed' size='0.52' color='#CFF5EE'>%1°</t>",
    _digits
];

_headingCtrl ctrlShow true;
_headingCtrl ctrlCommit 0;

true