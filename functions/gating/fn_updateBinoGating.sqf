if (!ZuluFX_nvgActive) exitWith {
    ZuluFX_binoExposureLeftTarget=0;
    ZuluFX_binoExposureRightTarget=0;
    ZuluFX_binoExposureLeft=0;
    ZuluFX_binoExposureRight=0;

    ZuluFX_gateLeftTarget=0;
    ZuluFX_gateRightTarget=0;
    ZuluFX_gateLeft=0;
    ZuluFX_gateRight=0;

    ZuluFX_gateLeftActive=0;
    ZuluFX_gateRightActive=0;
    ZuluFX_gateLeftDeficit=0;
    ZuluFX_gateRightDeficit=0;

    ZuluFX_binoGateLastTime=diag_tickTime;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_binoGateLastTime",_now-0.05];
private _dt=(_now-_last) max 0 min 0.25;
ZuluFX_binoGateLastTime=_now;

if (_dt<=0) exitWith {};

private _targets=call ZuluFX_fnc_calculateBinoExposure;
private _leftTarget=(_targets select 0) max 0 min 1;
private _rightTarget=(_targets select 1) max 0 min 1;

private _tubeBleed=0.15;
private _leftEff=_leftTarget max (_rightTarget*_tubeBleed);
private _rightEff=_rightTarget max (_leftTarget*_tubeBleed);

ZuluFX_binoExposureLeftTarget=_leftEff;
ZuluFX_binoExposureRightTarget=_rightEff;

private _leftAdapt=missionNamespace getVariable ["ZuluFX_binoExposureLeft",_leftEff];
private _rightAdapt=missionNamespace getVariable ["ZuluFX_binoExposureRight",_rightEff];

private _tauAttack=0.08;
private _tauRecover=0.30;

private _leftTau=[_tauRecover,_tauAttack] select (_leftEff>_leftAdapt);
private _rightTau=[_tauRecover,_tauAttack] select (_rightEff>_rightAdapt);

private _leftK=1-exp (-_dt/_leftTau);
private _rightK=1-exp (-_dt/_rightTau);

_leftAdapt=_leftAdapt+((_leftEff-_leftAdapt)*_leftK);
_rightAdapt=_rightAdapt+((_rightEff-_rightAdapt)*_rightK);

_leftAdapt=_leftAdapt max 0 min 1;
_rightAdapt=_rightAdapt max 0 min 1;

ZuluFX_binoExposureLeft=_leftAdapt;
ZuluFX_binoExposureRight=_rightAdapt;

private _maxGate=0.30;
private _gateHalf=0.22;

private _leftActive=_maxGate*_leftAdapt/(_leftAdapt+_gateHalf);
private _rightActive=_maxGate*_rightAdapt/(_rightAdapt+_gateHalf);

private _sceneFloor=0.05;
private _deficitK=0.05;

private _leftDeficit=0;
if (_leftAdapt>_leftEff) then {
    private _ratio=_leftAdapt/(_leftEff max _sceneFloor);
    private _excess=(_ratio-1) max 0;
    _leftDeficit=1-(1/(1+(_deficitK*_excess)));
};

private _rightDeficit=0;
if (_rightAdapt>_rightEff) then {
    private _ratio=_rightAdapt/(_rightEff max _sceneFloor);
    private _excess=(_ratio-1) max 0;
    _rightDeficit=1-(1/(1+(_deficitK*_excess)));
};

private _strength=2.3;
private _alphaCeil=0.92;

private _leftOutput=(_leftActive*_strength) min _alphaCeil;
private _rightOutput=(_rightActive*_strength) min _alphaCeil;

ZuluFX_gateLeftActive=_leftActive;
ZuluFX_gateRightActive=_rightActive;

ZuluFX_gateLeftDeficit=_leftDeficit;
ZuluFX_gateRightDeficit=_rightDeficit;

ZuluFX_gateLeftTarget=_leftOutput;
ZuluFX_gateRightTarget=_rightOutput;

ZuluFX_gateLeft=_leftOutput;
ZuluFX_gateRight=_rightOutput;