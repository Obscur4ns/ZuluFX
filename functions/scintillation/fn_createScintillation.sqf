if (!hasInterface) exitWith {false};
disableSerialization;

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {false};

private _pool=(missionNamespace getVariable ["ZuluFX_scintillationPoolSize",32]) max 8 min 64;
private _controls=uiNamespace getVariable ["ZuluFX_scintillationControls",[]];

private _valid=(count _controls)==_pool;
if (_valid) then {
    _valid=(_controls findIf {isNull _x})<0;
};

if (_valid) exitWith {true};

{
    if (!isNull _x) then {ctrlDelete _x};
} forEach _controls;

_controls=[];

for "_i" from 0 to (_pool-1) do {
    private _ctrl=_display ctrlCreate ["RscText",-1];
    _ctrl ctrlSetBackgroundColor [1,1,1,0];
    _ctrl ctrlSetPosition [safeZoneXAbs,safeZoneY,0.001,0.001];
    _ctrl ctrlEnable false;
    _ctrl ctrlShow false;
    _ctrl ctrlCommit 0;
    _controls pushBack _ctrl;
};

uiNamespace setVariable ["ZuluFX_scintillationControls",_controls];
true
