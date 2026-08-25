if (!hasInterface) exitWith {false};

ZuluFX_fusionActive=false;

if (!isNil "ZuluFX_fusionCandidatePFH") then {
    [ZuluFX_fusionCandidatePFH] call CBA_fnc_removePerFrameHandler;
    ZuluFX_fusionCandidatePFH=nil;
};

if (!isNil "ZuluFX_fusionTargetPFH") then {
    [ZuluFX_fusionTargetPFH] call CBA_fnc_removePerFrameHandler;
    ZuluFX_fusionTargetPFH=nil;
};

{
    if (!isNull _x) then {
        [_x] call ZuluFX_fnc_restoreFusionTarget;
    };
} forEach (missionNamespace getVariable ["ZuluFX_fusionTargets",[]]);

ZuluFX_fusionCandidates=[];
ZuluFX_fusionTargets=[];
true
