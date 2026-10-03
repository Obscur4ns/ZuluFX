if (!hasInterface) exitWith {};

ZuluFX_batteryStates=createHashMap;
ZuluFX_nvgBatteryLevel=-1;
ZuluFX_nvgLoadedBatteries=0;
ZuluFX_nvgBatteryLow=false;
ZuluFX_batteryLastTick=diag_tickTime;
ZuluFX_batteryPersistenceKey="";
ZuluFX_batteryPersistenceDirty=false;
ZuluFX_batteryPersistenceNextSave=diag_tickTime+30;

if (isNil "ZuluFX_batteryDrainScale") then {
    ZuluFX_batteryDrainScale=1;
};

[] call ZuluFX_fnc_loadBatteryStates;

if (!isNil "ZuluFX_batteryPFH") then {
    [ZuluFX_batteryPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_batteryPFH=[
    {
        [] call ZuluFX_fnc_updateBattery;

        if (
            missionNamespace getVariable ["ZuluFX_batteryPersistenceDirty",false] &&
            {diag_tickTime>=(missionNamespace getVariable ["ZuluFX_batteryPersistenceNextSave",0])}
        ) then {
            [] call ZuluFX_fnc_saveBatteryStates;
        };
    },
    1
] call CBA_fnc_addPerFrameHandler;

["visionMode",{
    params ["_unit","_newMode"];

    if (_unit isNotEqualTo player || {_newMode!=1}) exitWith {};
    if !(missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true]) exitWith {};

    [false,false] call ZuluFX_fnc_updateNVGProfile;

    if !(missionNamespace getVariable ["ZuluFX_nvgBatteryCapable",false]) exitWith {};

    private _state=[] call ZuluFX_fnc_getBatteryState;
    private _level=_state#0;
    private _cells=_state#1;
    private _required=missionNamespace getVariable ["ZuluFX_nvgRequiredBatteries",1];

    if (_level<=0 || {_cells<_required}) then {
        ZuluFX_fusionCyclePending=-1;
        ZuluFX_fusionReentry=false;
        ZuluFX_fusionVisionState=0;

        [{
            if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) then {
                [false] call ZuluFX_fnc_setFusion;
            };

            player action ["NVGogglesOff",player];
            ["NVG Battery Depleted",1.2] call CBA_fnc_notify;
        }] call CBA_fnc_execNextFrame;
    };
},true] call CBA_fnc_addPlayerEventHandler;

["loadout",{
    [{
        [false,false] call ZuluFX_fnc_updateNVGProfile;
        ZuluFX_batteryLastTick=diag_tickTime;
        [] call ZuluFX_fnc_updateBattery;
    }] call CBA_fnc_execNextFrame;
}] call CBA_fnc_addPlayerEventHandler;

addMissionEventHandler ["Ended",{
    [true] call ZuluFX_fnc_saveBatteryStates;
}];

private _display=findDisplay 46;

if (!isNull _display) then {
    _display displayAddEventHandler ["Unload",{
        [true] call ZuluFX_fnc_saveBatteryStates;
        false
    }];
};

[] call ZuluFX_fnc_initBatteryInteractions;

[{
    [true,false] call ZuluFX_fnc_updateNVGProfile;
    ZuluFX_batteryLastTick=diag_tickTime;
    [] call ZuluFX_fnc_updateBattery;
}] call CBA_fnc_execNextFrame;
