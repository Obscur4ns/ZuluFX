if (!hasInterface) exitWith {};

private _bypass=missionNamespace getVariable ["ZuluFX_debugVisualBypass",false];

if (_bypass) exitWith {
    ZuluFX_gateCommon=0;
    ZuluFX_gateVisualCommon=0;
    ZuluFX_gateGlobalDark=0;
    ZuluFX_gateLeftResidual=0;
    ZuluFX_gateRightResidual=0;
    ZuluFX_quadResiduals=[0,0,0,0];
    ZuluFX_gateGlobalLastTime=diag_tickTime;

    private _bino=uiNamespace getVariable ["ZuluFX_binoGatePictures",[]];
    {if (!isNull _x) then {_x ctrlSetTextColor [1,1,1,0]}} forEach _bino;

    private _quad=uiNamespace getVariable ["ZuluFX_quadGatePictures",[]];
    {if (!isNull _x) then {_x ctrlSetTextColor [1,1,1,0]}} forEach _quad;

    if (ZuluFX_ppGain>=0) then {
        ZuluFX_ppGain ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,1],[0.299,0.587,0.114,0]];
        ZuluFX_ppGain ppEffectCommit 0;
    };
};

if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_gateCommon=0;
    ZuluFX_gateVisualCommon=0;
    ZuluFX_gateGlobalDark=0;
    ZuluFX_gateLeftResidual=0;
    ZuluFX_gateRightResidual=0;
    ZuluFX_quadResiduals=[0,0,0,0];
    ZuluFX_gateGlobalLastTime=diag_tickTime;

    call ZuluFX_fnc_applyBinoRenderer;
    call ZuluFX_fnc_applyQuadRenderer;

    if (ZuluFX_ppGain>=0) then {
        ZuluFX_ppGain ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,1],[0.299,0.587,0.114,0]];
        ZuluFX_ppGain ppEffectCommit 0;
    };
};

private _mode=missionNamespace getVariable ["ZuluFX_tubeMode",0];

if (_mode==0) exitWith {
    disableSerialization;

    ZuluFX_gateCommon=0;
    ZuluFX_gateVisualCommon=0;
    ZuluFX_gateGlobalDark=0;
    ZuluFX_gateLeftResidual=0;
    ZuluFX_gateRightResidual=0;
    ZuluFX_quadResiduals=[0,0,0,0];
    ZuluFX_gateGlobalLastTime=diag_tickTime;

    private _binoMask=uiNamespace getVariable ["ZuluFX_binoOverlayPicture",controlNull];
    if (!isNull _binoMask) then {ctrlDelete _binoMask};

    {
        if (!isNull _x) then {ctrlDelete _x};
    } forEach (uiNamespace getVariable ["ZuluFX_binoOverlayEdges",[]]);

    {
        if (!isNull _x) then {ctrlDelete _x};
    } forEach (uiNamespace getVariable ["ZuluFX_binoGatePictures",[]]);

    private _quadMask=uiNamespace getVariable ["ZuluFX_quadOverlayPicture",controlNull];
    if (!isNull _quadMask) then {ctrlDelete _quadMask};

    {
        if (!isNull _x) then {ctrlDelete _x};
    } forEach (uiNamespace getVariable ["ZuluFX_quadOverlayEdges",[]]);

    {
        if (!isNull _x) then {ctrlDelete _x};
    } forEach (uiNamespace getVariable ["ZuluFX_quadGatePictures",[]]);

    uiNamespace setVariable ["ZuluFX_binoOverlayPicture",controlNull];
    uiNamespace setVariable ["ZuluFX_binoOverlayEdges",[]];
    uiNamespace setVariable ["ZuluFX_binoGatePictures",[]];
    uiNamespace setVariable ["ZuluFX_binoGatePosition",[]];
    uiNamespace setVariable ["ZuluFX_binoAperturePosition",[]];
    uiNamespace setVariable ["ZuluFX_binoGateAlpha",[-1,-1]];
    uiNamespace setVariable ["ZuluFX_binoRenderSignature",[]];

    uiNamespace setVariable ["ZuluFX_quadOverlayPicture",controlNull];
    uiNamespace setVariable ["ZuluFX_quadOverlayEdges",[]];
    uiNamespace setVariable ["ZuluFX_quadGatePictures",[]];
    uiNamespace setVariable ["ZuluFX_quadGatePosition",[]];
    uiNamespace setVariable ["ZuluFX_quadGateAlpha",[-1,-1,-1,-1]];
    uiNamespace setVariable ["ZuluFX_quadPosition",[]];
    uiNamespace setVariable ["ZuluFX_quadAperturePosition",[]];
    uiNamespace setVariable ["ZuluFX_quadRenderSignature",[]];

    private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
    if (!isNull _display) then {
        private _border=_display displayCtrl 1001;
        if (!isNull _border) then {_border ctrlShow true};
    };

    if (ZuluFX_ppGain>=0) then {
        ZuluFX_ppGain ppEffectAdjust [1,1,0,[0,0,0,0],[1,1,1,1],[0.299,0.587,0.114,0]];
        ZuluFX_ppGain ppEffectCommit 0;
    };
};

private _gates=[];
private _common=0;

if (_mode==4) then {
    _gates=missionNamespace getVariable ["ZuluFX_quadGates",[0,0,0,0]];
    if ((count _gates)!=4) then {_gates=[0,0,0,0]};
} else {
    private _left=missionNamespace getVariable ["ZuluFX_gateLeft",0];
    private _right=missionNamespace getVariable ["ZuluFX_gateRight",0];
    _gates=[_left,_right];
};

private _gatingStrength=missionNamespace getVariable ["ZuluFX_gatingStrength",0.72];
_gatingStrength=(_gatingStrength max 0) min 1;

for "_i" from 0 to ((count _gates)-1) do {
    private _v=_gates select _i;
    _v=(_v max 0 min 0.92)*_gatingStrength;
    _gates set [_i,_v];
};

_common=_gates select 0;
{
    if (_x<_common) then {_common=_x};
} forEach _gates;

private _target=_common min 0.90;

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_gateGlobalLastTime",_now-0.05];
private _dt=_now-_last;
_dt=_dt max 0 min 0.25;
ZuluFX_gateGlobalLastTime=_now;

private _global=missionNamespace getVariable ["ZuluFX_gateGlobalDark",0];

if (_dt>0) then {
    private _tau=0.14;
    if (_target>_global) then {_tau=0.045};
    private _k=1-exp(-_dt/_tau);
    _global=_global+((_target-_global)*_k);
};

_global=_global max 0 min 0.90;

ZuluFX_gateCommon=_common;
ZuluFX_gateVisualCommon=_global;
ZuluFX_gateGlobalDark=_global;

private _denom=(1-_global) max 0.001;

if (_mode==4) then {
    private _res=[0,0,0,0];

    for "_i" from 0 to 3 do {
        private _a=1-((1-(_gates select _i))/_denom);
        _a=_a max 0 min 1;
        _res set [_i,_a];
    };

    ZuluFX_quadResiduals=_res;

    private _old=uiNamespace getVariable ["ZuluFX_binoGatePictures",[]];
    {if (!isNull _x) then {_x ctrlSetTextColor [1,1,1,0]}} forEach _old;

    call ZuluFX_fnc_applyQuadRenderer;
} else {
    private _leftResidual=1-((1-(_gates select 0))/_denom);
    private _rightResidual=1-((1-(_gates select 1))/_denom);

    _leftResidual=_leftResidual max 0 min 1;
    _rightResidual=_rightResidual max 0 min 1;

    ZuluFX_gateLeftResidual=_leftResidual;
    ZuluFX_gateRightResidual=_rightResidual;

    private _old=uiNamespace getVariable ["ZuluFX_quadGatePictures",[]];
    {if (!isNull _x) then {_x ctrlSetTextColor [1,1,1,0]}} forEach _old;

    call ZuluFX_fnc_applyBinoRenderer;
};

private _gain=missionNamespace getVariable ["ZuluFX_gain",1];
_gain=_gain max 1 min 1.35;

private _gainDemand=(_gain-1)/0.35;
_gainDemand=_gainDemand max 0 min 1;

private _gainBoost=1+(0.08*_gainDemand);
private _gateBrightness=1-_global;
private _brightness=_gainBoost*_gateBrightness;

_brightness=_brightness max 0.10 min 1.08;

ZuluFX_gainDemand=_gainDemand;
ZuluFX_gainApplied=_gainBoost;
ZuluFX_gainBrightness=_brightness;
ZuluFX_gateFactor=_gateBrightness;
ZuluFX_gateContrast=1.00;
ZuluFX_gateOffset=0.00;

if (ZuluFX_ppGain>=0) then {
    ZuluFX_ppGain ppEffectAdjust [
        _brightness,
        1.00,
        0.00,
        [0,0,0,0],
        [1,1,1,0.95],
        [0.299,0.587,0.114,0]
    ];
    ZuluFX_ppGain ppEffectCommit 0;
};