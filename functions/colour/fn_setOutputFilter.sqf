params [["_enabled",true,[true]],["_filter","",[""]]];
if (!hasInterface) exitWith {false};

if (isNil "ZuluFX_ppOutputFilter") then {ZuluFX_ppOutputFilter=-1};
if (isNil "ZuluFX_ppOutputFilterLate") then {ZuluFX_ppOutputFilterLate=-1};
if (isNil "ZuluFX_outputFilter") then {ZuluFX_outputFilter="NONE"};

if (ZuluFX_ppOutputFilter<0) then {
    private _priority=2410;
    while {ZuluFX_ppOutputFilter<0} do {
        ZuluFX_ppOutputFilter=ppEffectCreate ["ColorCorrections",_priority];
        _priority=_priority+1;
    };
    ZuluFX_ppOutputFilter ppEffectForceInNVG true;
    ZuluFX_ppOutputFilter ppEffectEnable false;
};

if (ZuluFX_ppOutputFilterLate<0) then {
    private _priority=16760;
    while {ZuluFX_ppOutputFilterLate<0} do {
        ZuluFX_ppOutputFilterLate=ppEffectCreate ["ColorCorrections",_priority];
        _priority=_priority+1;
    };
    ZuluFX_ppOutputFilterLate ppEffectForceInNVG true;
    ZuluFX_ppOutputFilterLate ppEffectEnable false;
};

if (_filter!="") then {ZuluFX_outputFilter=toUpper _filter};
ZuluFX_outputFilterEnabled=_enabled;

ZuluFX_ppOutputFilter ppEffectEnable false;
ZuluFX_ppOutputFilterLate ppEffectEnable false;

if (!_enabled) exitWith {true};

switch (ZuluFX_outputFilter) do {
    case "AMBER": {
        ZuluFX_outputFilterBrightness=0.96;
        ZuluFX_outputFilterColour=[0.78,1.00,0.30];
        ZuluFX_outputFilterStrength=0.22;

        ZuluFX_ppOutputFilter ppEffectEnable true;
        ZuluFX_ppOutputFilter ppEffectAdjust [
            0.96,
            1,
            0,
            [0,0,0,0],
            [0.78,1.00,0.30,0.22],
            [0.299,0.587,0.114,0]
        ];
        ZuluFX_ppOutputFilter ppEffectCommit 0;
    };
    case "ONYX": {
        ZuluFX_outputFilterBrightness=0.90;
        ZuluFX_outputFilterColour=[1,1,1];
        ZuluFX_outputFilterStrength=1;

        ZuluFX_ppOutputFilterLate ppEffectEnable true;
        ZuluFX_ppOutputFilterLate ppEffectAdjust [
            0.90,
            1,
            0,
            [0,0,0,0],
            [1,1,1,0],
            [0.299,0.587,0.114,0]
        ];
        ZuluFX_ppOutputFilterLate ppEffectCommit 0;
    };
    case "NONE": {};
    default {ZuluFX_outputFilter="NONE"};
};

true