if (!ZuluFX_nvgActive) exitWith {0};

private _gain=missionNamespace getVariable ["ZuluFX_gain",1];
private _control=missionNamespace getVariable ["ZuluFX_gainControl",0];

private _gainDrive=(_gain-1)/0.35;
_gainDrive=_gainDrive max 0 min 1;

private _darkness=1-_control;
_darkness=_darkness max 0 min 1;

private _drive=(_gainDrive*0.82)+(_darkness*0.18);
_drive=_drive max 0 min 1;

private _intensity=0.030+(0.105*_drive);

ZuluFX_grainDrive=_drive;
ZuluFX_grainTarget=_intensity;

_intensity