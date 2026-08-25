private _item=hmd player;

if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

private _mode=missionNamespace getVariable ["ZuluFX_nvgTubeMode",0];
private _aspect=getResolution select 4;
private _wide=_aspect>2;

ZuluFX_gateAspect=_aspect;
ZuluFX_gateWide=_wide;

if !(_mode in [2,4]) exitWith {
    ZuluFX_gateProfile=-1;
    ZuluFX_gateLayoutState=[];
    0
};

private _profile=if (_mode==4) then {
    if (_wide) then {3} else {2}
} else {
    if (_wide) then {1} else {0}
};

private _state=[_mode,_profile];

if !((missionNamespace getVariable ["ZuluFX_gateLayoutState",[]]) isEqualTo _state) then {
    switch (_profile) do {
        case 0: {
            ZuluFX_binoSampleXs=[0.30,0.3667,0.4333,0.50,0.5667,0.6333,0.70];
            ZuluFX_binoSampleYs=[0.36,0.50,0.64];
        };
        case 1: {
            ZuluFX_binoSampleXs=[0.36,0.405,0.45,0.50,0.55,0.595,0.64];
            ZuluFX_binoSampleYs=[0.42,0.50,0.58];
        };
        case 2: {
            ZuluFX_quadTubeCentres=[0.275,0.425,0.575,0.725];
            ZuluFX_quadSampleXs=[0.18,0.26,0.34,0.42,0.50,0.58,0.66,0.74,0.82];
            ZuluFX_quadSampleYs=[0.36,0.50,0.64];
            ZuluFX_quadSigma=0.13;
        };
        case 3: {
            ZuluFX_quadTubeCentres=[0.388672,0.447266,0.557617,0.615723];
            ZuluFX_quadSampleXs=[0.30,0.35,0.40,0.45,0.50,0.55,0.60,0.65,0.70];
            ZuluFX_quadSampleYs=[0.42,0.50,0.58];
            ZuluFX_quadSigma=0.08;
        };
    };

    ZuluFX_gateLayoutState=_state;
};

ZuluFX_gateProfile=_profile;
_mode