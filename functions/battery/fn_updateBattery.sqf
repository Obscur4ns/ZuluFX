if (!hasInterface || {isNull player}) exitWith {false};

private _item=hmd player;
if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_batteryLastTick",_now];
private _elapsed=((_now-_last) max 0) min 5;
ZuluFX_batteryLastTick=_now;

if !(missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true]) exitWith {
    ZuluFX_nvgBatteryLevel=-1;
    ZuluFX_nvgLoadedBatteries=0;
    ZuluFX_nvgBatteryLow=false;
    false
};

if !(missionNamespace getVariable ["ZuluFX_nvgBatteryCapable",false]) exitWith {
    ZuluFX_nvgBatteryLevel=-1;
    ZuluFX_nvgLoadedBatteries=0;
    ZuluFX_nvgBatteryLow=false;
    false
};

private _state=[] call ZuluFX_fnc_getBatteryState;
private _level=_state#0;
private _cells=_state#1;
private _required=missionNamespace getVariable ["ZuluFX_nvgRequiredBatteries",1];

ZuluFX_nvgBatteryLevel=_level;
ZuluFX_nvgLoadedBatteries=_cells;

private _operational=_level>0 && {_cells>=_required};

if ([] call ZuluFX_fnc_isNVGActive && {!_operational}) exitWith {
    ZuluFX_nvgBatteryLow=false;
    ZuluFX_fusionCyclePending=-1;
    ZuluFX_fusionReentry=false;
    ZuluFX_fusionVisionState=0;

    if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
        [false] call ZuluFX_fnc_setFusion;
    };

    player action ["NVGogglesOff",player];
    false
};

if ([] call ZuluFX_fnc_isNVGActive && {_operational}) then {
    private _runtime=[] call ZuluFX_fnc_getBatteryRuntime;

    if (_runtime>0) then {
        private _fusionMultiplier=1;

        if (
            missionNamespace getVariable ["ZuluFX_fusionActive",false] &&
            {(missionNamespace getVariable ["ZuluFX_fusionVisionState",0])==2}
        ) then {
            _fusionMultiplier=missionNamespace getVariable [
                "ZuluFX_settingBatteryFusionDrainMultiplier",
                2
            ];
        };

        private _scale=missionNamespace getVariable ["ZuluFX_batteryDrainScale",1];
        _scale=(_scale max 0) min 100000;

        private _old=_level;
        private _drain=(_elapsed/(_runtime*3600))*_fusionMultiplier*_scale;
        _level=(_level-_drain) max 0;

        [_level] call ZuluFX_fnc_setBatteryLevel;

        if (_old>0 && {_level<=0}) then {
            ZuluFX_fusionCyclePending=-1;
            ZuluFX_fusionReentry=false;
            ZuluFX_fusionVisionState=0;

            if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
                [false] call ZuluFX_fnc_setFusion;
            };

            player action ["NVGogglesOff",player];
            ["NVG Battery Depleted",1.5] call CBA_fnc_notify;
        };
    };
};

private _threshold=missionNamespace getVariable ["ZuluFX_nvgBatteryLowThreshold",0.20];
ZuluFX_nvgBatteryLow=
    _level>0 &&
    {_level<=_threshold} &&
    {_cells>=_required};

true
