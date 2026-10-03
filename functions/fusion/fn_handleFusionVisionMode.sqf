params ["_unit","_newMode"];

if (!hasInterface || {_unit isNotEqualTo player}) exitWith {false};

if (_newMode==1) exitWith {
    if (missionNamespace getVariable ["ZuluFX_fusionReentry",false]) then {
        ZuluFX_fusionReentry=false;
        ZuluFX_fusionVisionState=2;
        [true] call ZuluFX_fnc_setFusion;
    } else {
        ZuluFX_fusionVisionState=1;
        [false] call ZuluFX_fnc_setFusion;
    };

    ZuluFX_fusionCyclePending=-1;
    true
};

[{
    private _pending=missionNamespace getVariable ["ZuluFX_fusionCyclePending",-1];

    [false] call ZuluFX_fnc_setFusion;

    if (
        _pending==1 &&
        {missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]} &&
        {(hmd player)!=""}
    ) then {
        ZuluFX_fusionVisionState=2;
        ZuluFX_fusionReentry=true;
        ZuluFX_fusionCyclePending=-1;

        player action ["NVGoggles",player];

        [{
            if (
                missionNamespace getVariable ["ZuluFX_fusionReentry",false] &&
                {!([] call ZuluFX_fnc_isNVGActive)}
            ) then {
                ZuluFX_fusionReentry=false;
                ZuluFX_fusionVisionState=0;
            };
        },[],0.25] call CBA_fnc_waitAndExecute;
    } else {
        ZuluFX_fusionVisionState=0;
        ZuluFX_fusionReentry=false;
        ZuluFX_fusionCyclePending=-1;
    };
}] call CBA_fnc_execNextFrame;

true
