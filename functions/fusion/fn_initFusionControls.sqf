if (!hasInterface) exitWith {false};

ZuluFX_fusionActive=false;
ZuluFX_fusionCandidates=[];
ZuluFX_fusionTargets=[];
ZuluFX_fusionVisionState=if ([] call ZuluFX_fnc_isNVGActive) then {1} else {0};
ZuluFX_fusionCyclePending=-1;
ZuluFX_fusionReentry=false;

ZuluFX_fusionNightVisionEH=addUserActionEventHandler [
    "nightVision",
    "Activate",
    {
        [] call ZuluFX_fnc_handleFusionVisionInput;
    }
];

["visionMode",{
    _this call ZuluFX_fnc_handleFusionVisionMode;
},true] call CBA_fnc_addPlayerEventHandler;

["ZuluFX","ZuluFX"] call CBA_fnc_registerKeybindModPrettyName;

[
    "ZuluFX",
    "ZuluFX_cycleFusionMode",
    [
        "Cycle Fusion Mode",
        "Cycles between Fusion presentation modes supported by the equipped NVG."
    ],
    {
        [] call ZuluFX_fnc_cycleFusionMode;
    },
    {},
    [0,[false,false,false]],
    false
] call CBA_fnc_addKeybind;

private _condition={
    private _item=hmd _player;
    if (_item=="") exitWith {false};

    if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
        [true,false] call ZuluFX_fnc_updateNVGProfile;
    };

    missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]
};

private _modifier={
    params ["_target","_player","_params","_actionData"];
    private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);
    private _label=if (_mode=="OUTLINE") then {"Outline"} else {"Patrol"};
    _actionData set [1,format ["Fusion Mode: %1",_label]];
};

private _parent=[
    "ZuluFX_FusionMode",
    "Fusion Mode",
    "",
    {},
    _condition,
    {},
    [],
    [0,0,0],
    2,
    [false,false,false,false,false],
    _modifier
] call ace_interact_menu_fnc_createAction;

[
    "CAManBase",
    1,
    ["ACE_SelfActions","ACE_Equipment"],
    _parent,
    true
] call ace_interact_menu_fnc_addActionToClass;

private _patrol=[
    "ZuluFX_FusionPatrol",
    "Patrol",
    "",
    {
        ["PATROL",true] call ZuluFX_fnc_setFusionMode;
    },
    {
        "PATROL" in (missionNamespace getVariable ["ZuluFX_nvgFusionModes",[]])
    }
] call ace_interact_menu_fnc_createAction;

[
    "CAManBase",
    1,
    ["ACE_SelfActions","ACE_Equipment","ZuluFX_FusionMode"],
    _patrol,
    true
] call ace_interact_menu_fnc_addActionToClass;

private _outline=[
    "ZuluFX_FusionOutline",
    "Outline",
    "",
    {
        ["OUTLINE",true] call ZuluFX_fnc_setFusionMode;
    },
    {
        "OUTLINE" in (missionNamespace getVariable ["ZuluFX_nvgFusionModes",[]])
    }
] call ace_interact_menu_fnc_createAction;

[
    "CAManBase",
    1,
    ["ACE_SelfActions","ACE_Equipment","ZuluFX_FusionMode"],
    _outline,
    true
] call ace_interact_menu_fnc_addActionToClass;

true
