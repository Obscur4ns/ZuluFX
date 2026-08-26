if (!hasInterface) exitWith {false};

private _check=[
    "ZuluFX_CheckNVGBattery",
    "Check NVG Battery",
    "",
    {
        private _state=[] call ZuluFX_fnc_getBatteryState;
        private _level=_state#0;
        private _cells=_state#1;
        private _max=missionNamespace getVariable ["ZuluFX_nvgMaxBatteries",0];

        [format ["NVG Battery: %1%% | %2/%3 cells",round (_level*100),_cells,_max],1.5] call CBA_fnc_notify;
    },
    {
        missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true] &&
        {missionNamespace getVariable ["ZuluFX_nvgBatteryCapable",false]}
    }
] call ace_interact_menu_fnc_createAction;

["CAManBase",1,["ACE_SelfActions","ACE_Equipment"],_check,true] call ace_interact_menu_fnc_addActionToClass;

private _load=[
    "ZuluFX_LoadCR123A",
    "Load CR123A",
    "",
    {
        [] call ZuluFX_fnc_loadBattery;
    },
    {
        if !(missionNamespace getVariable ["ZuluFX_settingBatteryEnabled",true]) exitWith {false};
        if !(missionNamespace getVariable ["ZuluFX_nvgBatteryCapable",false]) exitWith {false};

        private _max=missionNamespace getVariable ["ZuluFX_nvgMaxBatteries",0];
        if (_max<=0) exitWith {false};

        private _state=[] call ZuluFX_fnc_getBatteryState;
        private _level=_state#0;
        private _cells=_state#1;

        if (_cells>=_max && {_level>=0.999}) exitWith {false};

        [_player,"ZuluFX_Battery_CR123A"] call ace_common_fnc_hasItem
    }
] call ace_interact_menu_fnc_createAction;

["CAManBase",1,["ACE_SelfActions","ACE_Equipment"],_load,true] call ace_interact_menu_fnc_addActionToClass;

true
