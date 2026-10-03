if (!hasInterface || {isNull player}) exitWith {false};

private _item=hmd player;
if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]) exitWith {
    ZuluFX_fusionCyclePending=-1;
    false
};

ZuluFX_fusionCyclePending=missionNamespace getVariable [
    "ZuluFX_fusionVisionState",
    if ([] call ZuluFX_fnc_isNVGActive) then {1} else {0}
];

true
