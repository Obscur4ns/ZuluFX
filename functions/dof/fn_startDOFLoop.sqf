if (!hasInterface) exitWith {-1};

private _existing=missionNamespace getVariable ["ZuluFX_dofPFH",-1];
if (_existing>=0) exitWith {_existing};

private _pp=call ZuluFX_fnc_createDOF;
if (_pp<0) exitWith {-1};

ZuluFX_dofCandidate=-1;
ZuluFX_dofTarget=-1;
ZuluFX_dofFocus=-1;
ZuluFX_dofRenderFocus=5;
ZuluFX_dofBlur=1;
ZuluFX_dofMove=0;
ZuluFX_dofSamples=[];
ZuluFX_dofLastUpdate=diag_tickTime;

ZuluFX_dofPFH=[{
    call ZuluFX_fnc_updateDOF;
},0.05] call CBA_fnc_addPerFrameHandler;

ZuluFX_dofPFH