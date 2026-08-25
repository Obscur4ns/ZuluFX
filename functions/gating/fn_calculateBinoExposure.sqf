private _samples = call ZuluFX_fnc_sampleBino;
private _transient = call ZuluFX_fnc_sampleTransientLights;
private _persistent = call ZuluFX_fnc_samplePersistentLights;

private _leftDynamic = (_samples select 0) max 0;
private _rightDynamic = (_samples select 1) max 0;
private _leftTransient = (_transient select 0) max 0;
private _rightTransient = (_transient select 1) max 0;
private _leftPersistent = (_persistent select 0) max 0;
private _rightPersistent = (_persistent select 1) max 0;

ZuluFX_binoDynamicLeft = _leftDynamic;
ZuluFX_binoDynamicRight = _rightDynamic;
ZuluFX_binoTransientLeft = _leftTransient;
ZuluFX_binoTransientRight = _rightTransient;
ZuluFX_binoPersistentLeft = _leftPersistent;
ZuluFX_binoPersistentRight = _rightPersistent;

private _leftInput = _leftDynamic max _leftTransient max _leftPersistent;
private _rightInput = _rightDynamic max _rightTransient max _rightPersistent;

private _response = {
    params ["_value"];
    (1 - exp (-_value / 22)) max 0 min 1
};

private _left = [_leftInput] call _response;
private _right = [_rightInput] call _response;

ZuluFX_binoRawExposureLeft = _left;
ZuluFX_binoRawExposureRight = _right;
[_left,_right]