params [["_enabled",true,[true]],["_profile","",[""]]];
if (!hasInterface) exitWith {false};

if (isNil "ZuluFX_phosphorProfile") then {ZuluFX_phosphorProfile=missionNamespace getVariable ["ZuluFX_settingPhosphor","P45"]};
if (_profile!="") then {ZuluFX_phosphorProfile=toUpper _profile};

switch (ZuluFX_phosphorProfile) do {
    case "WP": {ZuluFX_phosphorProfile="P45"};
    case "GP": {ZuluFX_phosphorProfile="P43"};
};

if (isNil "ZuluFX_ppPhosphor") then {ZuluFX_ppPhosphor=-1};
if (isNil "ZuluFX_ppPhosphorLate") then {ZuluFX_ppPhosphorLate=-1};

if (ZuluFX_ppPhosphor<0) then {
    private _priority=2400;
    while {ZuluFX_ppPhosphor<0} do {
        ZuluFX_ppPhosphor=ppEffectCreate ["ColorCorrections",_priority];
        _priority=_priority+1;
    };
    ZuluFX_ppPhosphor ppEffectForceInNVG true;
    ZuluFX_ppPhosphor ppEffectEnable false;
};

if (ZuluFX_ppPhosphorLate<0) then {
    private _priority=16750;
    while {ZuluFX_ppPhosphorLate<0} do {
        ZuluFX_ppPhosphorLate=ppEffectCreate ["ColorCorrections",_priority];
        _priority=_priority+1;
    };
    ZuluFX_ppPhosphorLate ppEffectForceInNVG true;
    ZuluFX_ppPhosphorLate ppEffectEnable false;
};

ZuluFX_phosphorEnabled=_enabled;
ZuluFX_ppPhosphor ppEffectEnable false;
ZuluFX_ppPhosphorLate ppEffectEnable false;

if (!_enabled) exitWith {true};

if (ZuluFX_phosphorProfile=="NATIVE") exitWith {
    if (!isNil "ace_nightvision_fnc_refreshGoggleType") then {
        [] call ace_nightvision_fnc_refreshGoggleType;
        [{
            [] call ace_nightvision_fnc_refreshGoggleType;
            ace_nightvision_nextEffectsUpdate=-1;
        }] call CBA_fnc_execNextFrame;
    } else {
        ace_nightvision_nextEffectsUpdate=-1;
    };
    true
};

private _brightness=1.12;
private _aceColorize=[1.1,0.8,1.9,0.9];
private _aceWeight=[1,1,6,0];
private _finish=[0.68,0.92,1.00];
private _late=[];

switch (ZuluFX_phosphorProfile) do {
    case "P43": {
        _aceColorize=[1.3,1.2,0,0.9];
        _aceWeight=[6,1,1,0];
        _finish=[1,1,1];
    };
    case "P11": {
        _aceColorize=[0.10,0.18,1.90,0.9];
        _aceWeight=[1,1,6,0];
        _finish=[1,1,1];
    };
    case "P22R": {
        _finish=[1,1,1];
        _late=[1,1,0,[0,0,0,0],[0.698,0.227,0.227,0],[0.45,0.45,0.45,0.45]];
    };
    case "CUSTOM": {
        private _colour=+(missionNamespace getVariable ["ZuluFX_settingCustomColour",missionNamespace getVariable ["ZuluFX_customPhosphorColour",[1,1,1]]]);
        if ((count _colour)<3) then {_colour=[1,1,1]};
        _colour resize 3;
        _colour=_colour apply {(_x max 0) min 1};
        _brightness=(missionNamespace getVariable ["ZuluFX_settingCustomBrightness",missionNamespace getVariable ["ZuluFX_customPhosphorBrightness",1.12]]) max 0.50 min 1.50;
        ZuluFX_customPhosphorColour=_colour;
        ZuluFX_customPhosphorBrightness=_brightness;
        _finish=[1,1,1];
        _late=[1,1,0,[0,0,0,0],[_colour#0,_colour#1,_colour#2,0],[0.45,0.45,0.45,0.45]];
    };
    case "P45": {};
    default {
        ZuluFX_phosphorProfile="P45";
    };
};

ace_nightvision_nvgOffset=0;
ace_nightvision_nvgBlend=[0,0,0,0];
ace_nightvision_nvgColorize=_aceColorize;
ace_nightvision_nvgWeight=_aceWeight;
ace_nightvision_nextEffectsUpdate=-1;

ZuluFX_phosphorBrightness=_brightness;
ZuluFX_phosphorColour=_finish;

ZuluFX_ppPhosphor ppEffectEnable true;
ZuluFX_ppPhosphor ppEffectAdjust [
    _brightness,
    1,
    0,
    [0,0,0,0],
    [_finish#0,_finish#1,_finish#2,1],
    [0.299,0.587,0.114,0]
];
ZuluFX_ppPhosphor ppEffectCommit 0;

if !(_late isEqualTo []) then {
    ZuluFX_ppPhosphorLate ppEffectEnable true;
    ZuluFX_ppPhosphorLate ppEffectAdjust _late;
    ZuluFX_ppPhosphorLate ppEffectCommit 0;
};

true