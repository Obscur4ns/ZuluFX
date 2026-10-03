private _profile=toUpper (missionNamespace getVariable ["ZuluFX_nvgBatteryProfile",""]);
private _base=switch (_profile) do {
    case "KESTREL": {
        missionNamespace getVariable ["ZuluFX_settingBatteryLifeKestrel",16]
    };
    case "BNVDF": {
        missionNamespace getVariable ["ZuluFX_settingBatteryLifeBNVDF",16]
    };
    case "GPNVG": {
        missionNamespace getVariable ["ZuluFX_settingBatteryLifeGPNVG",30]
    };
    default {0};
};

private _max=missionNamespace getVariable ["ZuluFX_nvgMaxBatteries",0];
if (_base<=0 || {_max<=0}) exitWith {0};

private _state=[] call ZuluFX_fnc_getBatteryState;
private _cells=_state#1;
private _required=missionNamespace getVariable ["ZuluFX_nvgRequiredBatteries",1];

if (_cells<_required) exitWith {0};

private _capacity=missionNamespace getVariable ["ZuluFX_nvgBatteryCapacityMultiplier",1];
private _cellRatio=(_cells/_max) max 0 min 1;

_base*_capacity*_cellRatio
