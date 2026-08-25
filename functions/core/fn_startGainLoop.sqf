if (!hasInterface) exitWith {};

if (!isNil "ZuluFX_gainPFH") then {
    [ZuluFX_gainPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_gainLastTime=diag_tickTime-0.05;
ZuluFX_gainScene=0;
ZuluFX_gainHistory=0;
ZuluFX_gainControl=0;

ZuluFX_gainPFH=[{
    call ZuluFX_fnc_updateGain;
},0.05] call CBA_fnc_addPerFrameHandler;