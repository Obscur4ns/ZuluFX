if (!hasInterface) exitWith {false};
disableSerialization;

private _existing=uiNamespace getVariable ["ZuluFX_fpanoControls",[]];
if ((count _existing)==4 && {(_existing findIf {isNull _x})<0}) exitWith {true};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach _existing;

private _display=findDisplay 46;
if (isNull _display) exitWith {false};

private _controls=[];

for "_i" from 0 to 3 do {
    private _ctrl=_display ctrlCreate ["RscStructuredText",-1];
    _ctrl ctrlSetStructuredText parseText "";
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;
    _controls pushBack _ctrl;
};

uiNamespace setVariable ["ZuluFX_fpanoControls",_controls];
true
