if (!hasInterface) exitWith {false};

disableSerialization;

private _controls=uiNamespace getVariable ["ZuluFX_scintillationControls",[]];

{
    if (!isNull _x) then {
        _x ctrlSetBackgroundColor [1,1,1,0];
        _x ctrlShow false;
    };
} forEach _controls;

ZuluFX_scintillationNextUpdate=0;
ZuluFX_scintillationDrive=0;
ZuluFX_scintillationAlpha=0;
ZuluFX_scintillationCount=0;

true
