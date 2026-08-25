if (!hasInterface) exitWith {false};
if !(call ZuluFX_fnc_canUseCompass) exitWith {false};

disableSerialization;

private _existing=uiNamespace getVariable ["ZuluFX_compassTicks",[]];

if ((count _existing)>0 && {(_existing findIf {!isNull _x})>=0}) exitWith {
    true
};

call ZuluFX_fnc_cleanupCompass;

private _display=findDisplay 46;
if (isNull _display) exitWith {false};

private _tickCount=15;
private _ticks=[];
private _labels=[];

for "_i" from 0 to (_tickCount-1) do {
    private _tick=_display ctrlCreate ["RscText",-1];
    _tick ctrlSetBackgroundColor [0.78,0.95,0.92,0.92];
    _tick ctrlEnable false;
    _tick ctrlShow false;
    _tick ctrlCommit 0;
    _ticks pushBack _tick;

    private _label=_display ctrlCreate ["RscStructuredText",-1];
    _label ctrlSetStructuredText parseText "";
    _label ctrlEnable false;
    _label ctrlShow false;
    _label ctrlCommit 0;
    _labels pushBack _label;
};

private _centre=_display ctrlCreate ["RscText",-1];
_centre ctrlSetBackgroundColor [0.82,1,0.96,1];
_centre ctrlEnable false;
_centre ctrlShow false;
_centre ctrlCommit 0;

private _heading=_display ctrlCreate ["RscStructuredText",-1];
_heading ctrlSetStructuredText parseText "";
_heading ctrlEnable false;
_heading ctrlShow false;
_heading ctrlCommit 0;

uiNamespace setVariable ["ZuluFX_compassTicks",_ticks];
uiNamespace setVariable ["ZuluFX_compassLabels",_labels];
uiNamespace setVariable ["ZuluFX_compassCentre",_centre];
uiNamespace setVariable ["ZuluFX_compassHeading",_heading];

if (!isNil "ZuluFX_compassPFH") then {
    [ZuluFX_compassPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_compassPFH=[{
    call ZuluFX_fnc_updateCompass;
},0.05] call CBA_fnc_addPerFrameHandler;

call ZuluFX_fnc_updateCompass;
true