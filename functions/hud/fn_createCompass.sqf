if (!hasInterface) exitWith {false};
if !(call ZuluFX_fnc_canUseCompass) exitWith {false};

disableSerialization;

private _existing=uiNamespace getVariable ["ZuluFX_compassTicks",[]];
if ((count _existing)>0 && {(_existing findIf {!isNull _x})>=0}) exitWith {true};

call ZuluFX_fnc_cleanupCompass;

private _display=findDisplay 46;
if (isNull _display) exitWith {false};

private _ticks=[];
private _bearings=[];
private _directions=[];

for "_i" from 0 to 14 do {
    private _tick=_display ctrlCreate ["RscText",-1];
    _tick ctrlSetBackgroundColor [1,1,1,0.90];
    _tick ctrlEnable false;
    _tick ctrlShow false;
    _tick ctrlCommit 0;
    _ticks pushBack _tick;

    private _bearing=_display ctrlCreate ["RscStructuredText",-1];
    _bearing ctrlSetStructuredText parseText "";
    _bearing ctrlEnable false;
    _bearing ctrlShow false;
    _bearing ctrlCommit 0;
    _bearings pushBack _bearing;

    private _direction=_display ctrlCreate ["RscStructuredText",-1];
    _direction ctrlSetStructuredText parseText "";
    _direction ctrlEnable false;
    _direction ctrlShow false;
    _direction ctrlCommit 0;
    _directions pushBack _direction;
};

private _centre=_display ctrlCreate ["RscText",-1];
_centre ctrlSetBackgroundColor [1,1,1,1];
_centre ctrlEnable false;
_centre ctrlShow false;
_centre ctrlCommit 0;

private _heading=_display ctrlCreate ["RscStructuredText",-1];
_heading ctrlSetStructuredText parseText "";
_heading ctrlEnable false;
_heading ctrlShow false;
_heading ctrlCommit 0;

uiNamespace setVariable ["ZuluFX_compassTicks",_ticks];
uiNamespace setVariable ["ZuluFX_compassLabels",_bearings];
uiNamespace setVariable ["ZuluFX_compassDirections",_directions];
uiNamespace setVariable ["ZuluFX_compassCentre",_centre];
uiNamespace setVariable ["ZuluFX_compassHeading",_heading];

call ZuluFX_fnc_updateCompass;
true
