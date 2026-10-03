if (!hasInterface) exitWith {false};
if !([] call ZuluFX_fnc_canUseFusion) exitWith {false};
if (missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {true};

private _modes=missionNamespace getVariable ["ZuluFX_nvgFusionModes",["PATROL"]];
private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode",missionNamespace getVariable ["ZuluFX_nvgFusionDefaultMode","PATROL"]]);

if !(_mode in _modes) then {
    _mode=toUpper (missionNamespace getVariable ["ZuluFX_nvgFusionDefaultMode","PATROL"]);
};

ZuluFX_fusionMode=_mode;
ZuluFX_fusionCandidates=[];
ZuluFX_fusionTargets=[];
ZuluFX_fusionActive=true;

[] call ZuluFX_fnc_scanFusionCandidates;
[] call ZuluFX_fnc_updateFusionTargets;

if (!isNil "ZuluFX_fusionCandidatePFH") then {
    [ZuluFX_fusionCandidatePFH] call CBA_fnc_removePerFrameHandler;
};

if (!isNil "ZuluFX_fusionTargetPFH") then {
    [ZuluFX_fusionTargetPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_fusionCandidatePFH=[
    {
        [] call ZuluFX_fnc_scanFusionCandidates;
    },
    0.75
] call CBA_fnc_addPerFrameHandler;

ZuluFX_fusionTargetPFH=[
    {
        [] call ZuluFX_fnc_updateFusionTargets;
    },
    0.05
] call CBA_fnc_addPerFrameHandler;

true
