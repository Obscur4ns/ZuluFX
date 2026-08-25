if (!hasInterface) exitWith {};

if (!isNil "ZuluFX_grainPFH") then {
    [ZuluFX_grainPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_grainLastTime=diag_tickTime-0.1;
ZuluFX_grainDrive=0;
ZuluFX_grainTarget=0;

ZuluFX_grainPFH=[{
    call ZuluFX_fnc_updateGrain;
},0.1] call CBA_fnc_addPerFrameHandler;