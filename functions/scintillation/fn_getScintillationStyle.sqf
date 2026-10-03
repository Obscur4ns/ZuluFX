private _drive=missionNamespace getVariable ["ZuluFX_grainDrive",0];
_drive=(_drive max 0) min 1;

private _curve=_drive*_drive;
private _profile=toUpper (missionNamespace getVariable [
    "ZuluFX_phosphorProfile",
    missionNamespace getVariable ["ZuluFX_settingPhosphor","P45"]
]);

private _colour=[0.74,0.93,1.00];
private _brightnessFactor=1;

switch (_profile) do {
    case "P43": {
        _colour=[0.72,1.00,0.56];
    };
    case "P11": {
        _colour=[0.42,0.58,1.00];
    };
    case "P22R": {
        _colour=[1.00,0.40,0.40];
    };
    case "CUSTOM": {
        private _custom=+(missionNamespace getVariable [
            "ZuluFX_settingCustomColour",
            missionNamespace getVariable ["ZuluFX_customPhosphorColour",[1,1,1]]
        ]);

        if ((count _custom)<3) then {_custom=[1,1,1]};
        _custom resize 3;
        _colour=_custom apply {(_x max 0) min 1};

        private _customBrightness=missionNamespace getVariable [
            "ZuluFX_settingCustomBrightness",
            missionNamespace getVariable ["ZuluFX_customPhosphorBrightness",1.12]
        ];

        _brightnessFactor=(_customBrightness/1.12) max 0.65 min 1.35;
    };
    case "NATIVE": {
        private _native=+(missionNamespace getVariable ["ace_nightvision_nvgColorize",[0.65,1,0.55,0.9]]);

        if ((count _native)>=3) then {
            _native resize 3;
            private _mx=0.001;

            {
                if (_x>_mx) then {_mx=_x};
            } forEach _native;

            _colour=_native apply {((_x/_mx) max 0) min 1};
        };
    };
    case "P45": {};
    default {
        _profile="P45";
    };
};

private _lightWhiteMix=0.05+(0.10*_curve);
_colour=[
    ((_colour#0)*(1-_lightWhiteMix))+_lightWhiteMix,
    ((_colour#1)*(1-_lightWhiteMix))+_lightWhiteMix,
    ((_colour#2)*(1-_lightWhiteMix))+_lightWhiteMix
];

private _filter=toUpper (missionNamespace getVariable [
    "ZuluFX_outputFilter",
    missionNamespace getVariable ["ZuluFX_settingOutputFilter","NONE"]
]);

switch (_filter) do {
    case "AMBER": {
        private _target=[1.00,0.88,0.42];
        private _mix=0.22;

        _colour=[
            ((_colour#0)*(1-_mix))+((_target#0)*_mix),
            ((_colour#1)*(1-_mix))+((_target#1)*_mix),
            ((_colour#2)*(1-_mix))+((_target#2)*_mix)
        ];

        _brightnessFactor=_brightnessFactor*0.94;
    };
    case "ONYX": {
        private _luma=((_colour#0)*0.299)+((_colour#1)*0.587)+((_colour#2)*0.114);
        private _mix=0.42;

        _colour=[
            ((_colour#0)*(1-_mix))+(_luma*_mix),
            ((_colour#1)*(1-_mix))+(_luma*_mix),
            ((_colour#2)*(1-_mix))+(_luma*_mix)
        ];

        _brightnessFactor=_brightnessFactor*0.88;
    };
};

private _strength=missionNamespace getVariable ["ZuluFX_scintillationStrength",1];
_strength=(_strength max 0) min 2;

private _alpha=(0.008+(0.135*_curve))*_brightnessFactor*_strength;
_alpha=(_alpha max 0) min 0.18;

private _density=0.12+(0.78*_curve);
private _rate=10+(20*_curve);

ZuluFX_scintillationDrive=_drive;
ZuluFX_scintillationAlpha=_alpha;
ZuluFX_scintillationRate=_rate;
ZuluFX_scintillationColour=_colour;

[_colour,_alpha,_density,_rate,_drive]
