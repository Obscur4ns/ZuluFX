if (!hasInterface) exitWith {};

if (!isNil "ZuluFX_gatingPFH") then {
    [ZuluFX_gatingPFH] call CBA_fnc_removePerFrameHandler;
};

if (isNil "ZuluFX_nvgActive") then {ZuluFX_nvgActive=false};
if (isNil "ZuluFX_ppGain") then {ZuluFX_ppGain=-1};

ZuluFX_gatingLoopTicks=0;
ZuluFX_gatingLoopMode=-1;
ZuluFX_gatingLoopProfile=-1;
ZuluFX_lastTubeState=[-1,-1];

ZuluFX_gatingPFH=[{
    ZuluFX_gatingLoopTicks=ZuluFX_gatingLoopTicks+1;

    private _mode=call ZuluFX_fnc_getTubeMode;
    private _profile=missionNamespace getVariable ["ZuluFX_gateProfile",-1];

    ZuluFX_gatingLoopMode=_mode;
    ZuluFX_gatingLoopProfile=_profile;

    private _last=missionNamespace getVariable ["ZuluFX_lastTubeState",[-1,-1]];
    private _changed=!([_mode,_profile] isEqualTo _last);

    if (_changed) then {
        ZuluFX_gateLeft=0;
        ZuluFX_gateRight=0;
        ZuluFX_gateLeftTarget=0;
        ZuluFX_gateRightTarget=0;
        ZuluFX_gateLeftResidual=0;
        ZuluFX_gateRightResidual=0;
        ZuluFX_binoExposureLeft=0;
        ZuluFX_binoExposureRight=0;
        ZuluFX_binoProbeField=[];

        ZuluFX_quadExposure=[0,0,0,0];
        ZuluFX_quadExposureTarget=[0,0,0,0];
        ZuluFX_quadGateActive=[0,0,0,0];
        ZuluFX_quadGateDeficit=[0,0,0,0];
        ZuluFX_quadGates=[0,0,0,0];
        ZuluFX_quadResiduals=[0,0,0,0];
        ZuluFX_quadProbeField=[];
        ZuluFX_quadUpdateStage=0;

        ZuluFX_gateCommon=0;
        ZuluFX_gateVisualCommon=0;
        ZuluFX_gateGlobalDark=0;

        ZuluFX_binoGateLastTime=diag_tickTime-0.05;
        ZuluFX_quadGateLastTime=diag_tickTime-0.05;
        ZuluFX_gateGlobalLastTime=diag_tickTime-0.05;
        ZuluFX_lastTubeState=[_mode,_profile];

        if (_mode==0) then {
            call ZuluFX_fnc_applyGating;
        };
    };

    ZuluFX_tubeMode=_mode;

    switch (_mode) do {
        case 2: {
            call ZuluFX_fnc_updateBinoGating;
            call ZuluFX_fnc_applyGating;
        };
        case 4: {
            call ZuluFX_fnc_updateQuadGating;
            call ZuluFX_fnc_applyGating;
        };
    };
},0.05] call CBA_fnc_addPerFrameHandler;