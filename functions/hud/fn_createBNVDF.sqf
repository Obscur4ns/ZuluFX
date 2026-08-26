if (!hasInterface) exitWith {false};
disableSerialization;

private _existing=uiNamespace getVariable ["ZuluFX_bnvdfControls",[]];
private _frame=uiNamespace getVariable ["ZuluFX_bnvdfBatteryFrame",controlNull];
private _bars=uiNamespace getVariable ["ZuluFX_bnvdfBatteryBars",[]];

if (
    (count _existing)==5 &&
    {(_existing findIf {isNull _x})<0} &&
    {!isNull _frame} &&
    {(count _bars)==5} &&
    {(_bars findIf {isNull _x})<0}
) exitWith {true};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach _existing;

if (!isNull _frame) then {
    ctrlDelete _frame;
};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach _bars;

private _display=findDisplay 46;
if (isNull _display) exitWith {false};

private _controls=[];

for "_i" from 0 to 4 do {
    private _ctrl=_display ctrlCreate ["RscStructuredText",-1];
    _ctrl ctrlSetStructuredText parseText "";
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;
    _controls pushBack _ctrl;
};

_frame=_display ctrlCreate ["RscPictureKeepAspect",-1];
_frame ctrlSetText "\ZuluFX\data\hud\battery_icon_ca.paa";
_frame ctrlSetTextColor [0.81,0.96,0.93,0.95];
_frame ctrlEnable false;
_frame ctrlShow false;
_frame ctrlCommit 0;

_bars=[];

for "_i" from 0 to 4 do {
    private _bar=_display ctrlCreate ["RscText",-1];
    _bar ctrlSetBackgroundColor [0.81,0.96,0.93,0.95];
    _bar ctrlEnable false;
    _bar ctrlShow false;
    _bar ctrlCommit 0;
    _bars pushBack _bar;
};

uiNamespace setVariable ["ZuluFX_bnvdfControls",_controls];
uiNamespace setVariable ["ZuluFX_bnvdfBatteryFrame",_frame];
uiNamespace setVariable ["ZuluFX_bnvdfBatteryBars",_bars];

true