if (!ZuluFX_nvgActive) exitWith {1};

private _mode=missionNamespace getVariable ["ZuluFX_tubeMode",2];
private _sceneMean=0;
private _scenePeak=0;
private _adaptMean=0;
private _adaptPeak=0;

if (_mode==4) then {
    private _raw=missionNamespace getVariable ["ZuluFX_quadRawExposure",[0,0,0,0]];
    private _adapt=missionNamespace getVariable ["ZuluFX_quadExposure",[0,0,0,0]];
    private _sumRaw=0;
    private _sumAdapt=0;

    for "_i" from 0 to 3 do {
        private _r=_raw select _i;
        private _a=_adapt select _i;
        _sumRaw=_sumRaw+_r;
        _sumAdapt=_sumAdapt+_a;
        if (_r>_scenePeak) then {_scenePeak=_r};
        if (_a>_adaptPeak) then {_adaptPeak=_a};
    };

    _sceneMean=_sumRaw*0.25;
    _adaptMean=_sumAdapt*0.25;
} else {
    private _rawL=missionNamespace getVariable ["ZuluFX_binoRawExposureLeft",0];
    private _rawR=missionNamespace getVariable ["ZuluFX_binoRawExposureRight",0];
    private _adaptL=missionNamespace getVariable ["ZuluFX_binoExposureLeft",0];
    private _adaptR=missionNamespace getVariable ["ZuluFX_binoExposureRight",0];

    _sceneMean=(_rawL+_rawR)*0.5;
    _adaptMean=(_adaptL+_adaptR)*0.5;
    _scenePeak=_rawL max _rawR;
    _adaptPeak=_adaptL max _adaptR;
};

private _scene=(_sceneMean*0.65)+(_scenePeak*0.35);
private _history=(_adaptMean*0.70)+(_adaptPeak*0.30);

_scene=_scene max 0 min 1;
_history=_history max 0 min 1;

private _localControl=(_scene*0.72)+(_history*0.28);
_localControl=_localControl max 0 min 1;

private _ambient=missionNamespace getVariable ["ZuluFX_ambientBrightness",0];
private _sky=missionNamespace getVariable ["ZuluFX_skyExposure",0];

_ambient=_ambient max 0;
_sky=_sky max 0 min 1;

private _ambientEffective=_ambient*(0.25+(0.75*_sky));
private _ambientControl=1 - exp (-_ambientEffective/1.8);
_ambientControl=_ambientControl max 0 min 1;

private _control=1-((1-_localControl)*(1-_ambientControl));
_control=_control max 0 min 1;

private _target=1.35-(0.35*_control);
_target=_target max 1 min 1.35;

ZuluFX_gainScene=_scene;
ZuluFX_gainHistory=_history;
ZuluFX_gainLocalControl=_localControl;
ZuluFX_gainAmbient=_ambient;
ZuluFX_gainAmbientControl=_ambientControl;
ZuluFX_gainSky=_sky;
ZuluFX_gainControl=_control;
ZuluFX_targetGain=_target;

_target