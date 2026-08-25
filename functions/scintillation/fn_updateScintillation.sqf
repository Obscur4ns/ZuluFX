if (!hasInterface) exitWith {false};

if (
    !(missionNamespace getVariable ["ZuluFX_nvgActive",false]) ||
    {missionNamespace getVariable ["ZuluFX_debugVisualBypass",false]}
) exitWith {
    private _controls=uiNamespace getVariable ["ZuluFX_scintillationControls",[]];

    if ((count _controls)>0) then {
        [] call ZuluFX_fnc_cleanupScintillation;
    };

    false
};

private _mode=missionNamespace getVariable ["ZuluFX_nvgTubeMode",0];

if !(_mode in [2,4]) exitWith {
    [] call ZuluFX_fnc_cleanupScintillation;
    false
};

private _aperture=if (_mode==4) then {
    uiNamespace getVariable ["ZuluFX_quadAperturePosition",[]]
} else {
    uiNamespace getVariable ["ZuluFX_binoAperturePosition",[]]
};

if ((count _aperture)<4) exitWith {
    [] call ZuluFX_fnc_cleanupScintillation;
    false
};

if !([] call ZuluFX_fnc_createScintillation) exitWith {false};

private _now=diag_tickTime;
private _next=missionNamespace getVariable ["ZuluFX_scintillationNextUpdate",0];

if (_now<_next) exitWith {true};

private _style=[] call ZuluFX_fnc_getScintillationStyle;
_style params ["_colour","_baseAlpha","_density","_rate","_drive"];

private _interval=1/(_rate max 1);
ZuluFX_scintillationNextUpdate=_now+_interval;

private _controls=uiNamespace getVariable ["ZuluFX_scintillationControls",[]];
private _pool=count _controls;

private _maxVisible=if (_mode==4) then {38} else {26};
private _visible=round (_maxVisible*_density);
_visible=_visible+(floor (random 3))-1;
_visible=(_visible max 2) min (_maxVisible min _pool);

ZuluFX_scintillationCount=_visible;

_aperture params ["_ox","_oy","_ow","_oh"];

private _res=getResolution;
private _pixelW=safeZoneWAbs/((_res#0) max 1);
private _pixelH=safeZoneH/((_res#1) max 1);
private _globalPulse=0.90+(random 0.28);
private _hotChance=0.05+(0.07*(_drive*_drive));

for "_i" from 0 to (_pool-1) do {
    private _ctrl=_controls#_i;

    if (_i>=_visible) then {
        _ctrl ctrlShow false;
    } else {
        private _point=[_mode] call ZuluFX_fnc_randomScintillationPoint;
        private _px=_point#0;
        private _py=_point#1;

        private _sizeRoll=random 1;
        private _pixels=1.25;

        if (_sizeRoll>0.76) then {_pixels=1.75};
        if (_sizeRoll>0.95) then {_pixels=2.50};

        private _w=_pixelW*_pixels;
        private _h=_pixelH*_pixels;
        private _x=_ox+(_ow*_px)-(_w*0.5);
        private _y=_oy+(_oh*_py)-(_h*0.5);

        private _roll=random 1;
        private _mult=0.65+(random 0.38);
        private _hotMix=0;

        if (_roll>0.70) then {
            _mult=1.00+(random 0.35);
        };

        if (_roll>(1-_hotChance)) then {
            _mult=1.60+(random 0.45);
            _hotMix=0.22+(0.13*_drive);
        };

        private _alpha=(_baseAlpha*_mult*_globalPulse) min 0.28;

        private _r=((_colour#0)*(1-_hotMix))+_hotMix;
        private _g=((_colour#1)*(1-_hotMix))+_hotMix;
        private _b=((_colour#2)*(1-_hotMix))+_hotMix;

        _ctrl ctrlSetPosition [_x,_y,_w,_h];
        _ctrl ctrlSetBackgroundColor [_r,_g,_b,_alpha];
        _ctrl ctrlShow true;
        _ctrl ctrlCommit 0;
    };
};

true
