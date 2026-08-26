params [["_item",hmd player,[""]]];
private _profile=createHashMapFromArray [
    ["class",_item],
    ["supported",false],
    ["tubeMode",0],
    ["fusionCapable",false],
    ["fusionFOV",30],
    ["fusionModes",[]],
    ["fusionDefaultMode","PATROL"],
    ["fusionPatrolRange",500],
    ["fusionOutlineRange",300],
    ["fusionMaxRange",500],
    ["compassCapable",false],
    ["compassAnchor",[0.5,0.15]],
    ["hudMode","NONE"],
    ["batteryIndicator","NONE"],
    ["batteryIndicatorAnchor",[0.5,0.5]],
    ["batteryCapable",false],
    ["batteryProfile",""],
    ["maxBatteries",0],
    ["requiredBatteries",0],
    ["batteryCapacityMultiplier",1],
    ["batteryLowThreshold",0.20],
    ["batteryStateKey",""]
];
if (_item=="") exitWith {_profile};

private _cfg=configFile >> "CfgWeapons" >> _item;
if (!isClass _cfg) exitWith {_profile};

private _tubeMode=getNumber (_cfg >> "ZuluFX_tubeMode");
if !(_tubeMode in [2,4]) then {_tubeMode=0};

private _fusion=getNumber (_cfg >> "ZuluFX_fusionCapable")>0;
private _fusionFOV=getNumber (_cfg >> "ZuluFX_fusionFOV");
if (_fusionFOV<=0) then {_fusionFOV=30};
_fusionFOV=(_fusionFOV max 1) min 120;

private _fusionModes=[];
{
    if (_x isEqualType "") then {
        private _mode=toUpper _x;
        if (_mode in ["PATROL","OUTLINE"]) then {
            _fusionModes pushBackUnique _mode;
        };
    };
} forEach (getArray (_cfg >> "ZuluFX_fusionModes"));

if (_fusion && {(count _fusionModes)==0}) then {
    _fusionModes=["PATROL"];
};

private _fusionDefault=toUpper (getText (_cfg >> "ZuluFX_fusionDefaultMode"));
if !(_fusionDefault in _fusionModes) then {
    _fusionDefault=_fusionModes param [0,"PATROL"];
};

private _patrolRange=getNumber (_cfg >> "ZuluFX_fusionPatrolRange");
if (_patrolRange<=0) then {_patrolRange=500};

private _outlineRange=getNumber (_cfg >> "ZuluFX_fusionOutlineRange");
if (_outlineRange<=0) then {_outlineRange=300};
_outlineRange=_outlineRange min _patrolRange;

private _maxRange=_patrolRange max _outlineRange;
private _hudMode=toUpper (getText (_cfg >> "ZuluFX_hudMode"));
private _legacyCompass=getNumber (_cfg >> "ZuluFX_compassCapable")>0;

if !(_hudMode in ["NONE","COMPASS","BNVDF","FPANO"]) then {
    _hudMode=if (_legacyCompass) then {"COMPASS"} else {"NONE"};
};

private _compass=_legacyCompass || {_hudMode in ["COMPASS","BNVDF","FPANO"]};
private _anchor=getArray (_cfg >> "ZuluFX_compassAnchor");

if ((count _anchor)<2) then {
    _anchor=if (_tubeMode==4) then {[0.5,0.13]} else {[0.5,0.15]};
} else {
    _anchor=[
        ((_anchor#0) max 0) min 1,
        ((_anchor#1) max 0) min 1
    ];
};

private _batteryIndicator=toUpper (getText (_cfg >> "ZuluFX_batteryIndicator"));
if !(_batteryIndicator in ["NONE","LAMP","HUD"]) then {
    _batteryIndicator="NONE";
};

private _batteryAnchor=getArray (_cfg >> "ZuluFX_batteryIndicatorAnchor");
if ((count _batteryAnchor)<2) then {
    _batteryAnchor=[0.5,0.5];
} else {
    _batteryAnchor=[
        ((_batteryAnchor#0) max 0) min 1,
        ((_batteryAnchor#1) max 0) min 1
    ];
};

private _batteryProfile=toUpper (getText (_cfg >> "ZuluFX_batteryProfile"));
if !(_batteryProfile in ["KESTREL","BNVDF","GPNVG"]) then {
    _batteryProfile="";
};

private _maxBatteries=round (getNumber (_cfg >> "ZuluFX_maxBatteries"));
if (_maxBatteries<0) then {_maxBatteries=0};

private _requiredBatteries=round (getNumber (_cfg >> "ZuluFX_requiredBatteries"));
if (_requiredBatteries<=0 && {_maxBatteries>0}) then {_requiredBatteries=1};
_requiredBatteries=(_requiredBatteries max 0) min _maxBatteries;

private _batteryCapable=
    getNumber (_cfg >> "ZuluFX_batteryCapable")>0 &&
    {_batteryProfile!=""} &&
    {_maxBatteries>0};

private _capacityMultiplier=getNumber (_cfg >> "ZuluFX_batteryCapacityMultiplier");
if (_capacityMultiplier<=0) then {_capacityMultiplier=1};
_capacityMultiplier=(_capacityMultiplier max 0.1) min 20;

private _batteryLow=getNumber (_cfg >> "ZuluFX_batteryLowThreshold");
if (_batteryLow<=0) then {_batteryLow=0.20};
_batteryLow=(_batteryLow max 0.01) min 0.99;

private _batteryStateKey=getText (_cfg >> "ZuluFX_batteryStateKey");

_profile set ["supported",_tubeMode in [2,4]];
_profile set ["tubeMode",_tubeMode];
_profile set ["fusionCapable",_fusion];
_profile set ["fusionFOV",_fusionFOV];
_profile set ["fusionModes",_fusionModes];
_profile set ["fusionDefaultMode",_fusionDefault];
_profile set ["fusionPatrolRange",_patrolRange];
_profile set ["fusionOutlineRange",_outlineRange];
_profile set ["fusionMaxRange",_maxRange];
_profile set ["compassCapable",_compass];
_profile set ["compassAnchor",_anchor];
_profile set ["hudMode",_hudMode];
_profile set ["batteryIndicator",_batteryIndicator];
_profile set ["batteryIndicatorAnchor",_batteryAnchor];
_profile set ["batteryCapable",_batteryCapable];
_profile set ["batteryProfile",_batteryProfile];
_profile set ["maxBatteries",_maxBatteries];
_profile set ["requiredBatteries",_requiredBatteries];
_profile set ["batteryCapacityMultiplier",_capacityMultiplier];
_profile set ["batteryLowThreshold",_batteryLow];
_profile set ["batteryStateKey",_batteryStateKey];

_profile
