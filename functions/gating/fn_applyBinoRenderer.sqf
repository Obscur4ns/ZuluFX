if (!hasInterface) exitWith {false};
disableSerialization;

if !(missionNamespace getVariable ["ZuluFX_nvgActive",false]) exitWith {
    private _pics=uiNamespace getVariable ["ZuluFX_binoGatePictures",[]];

    {
        if (!isNull _x) then {
            _x ctrlSetTextColor [1,1,1,0];
            _x ctrlCommit 0;
        };
    } forEach _pics;

    uiNamespace setVariable ["ZuluFX_binoGateAlpha",[0,0]];
    true
};

[] call ZuluFX_fnc_createBinoRenderer;

private _pics=uiNamespace getVariable ["ZuluFX_binoGatePictures",[]];

if ((count _pics)!=2 || {(_pics findIf {isNull _x})>=0}) exitWith {
    false
};

private _left=(missionNamespace getVariable ["ZuluFX_gateLeftResidual",0]) max 0 min 1;
private _right=(missionNamespace getVariable ["ZuluFX_gateRightResidual",0]) max 0 min 1;

private _strength=missionNamespace getVariable ["ZuluFX_gatingLocalStrength",0.80];
_strength=(_strength max 0) min 1;

private _leftAlpha=_left*_strength;
private _rightAlpha=_right*_strength;

private _oldAlpha=uiNamespace getVariable ["ZuluFX_binoGateAlpha",[-1,-1]];

if !(_oldAlpha isEqualTo [_leftAlpha,_rightAlpha]) then {
    (_pics#0) ctrlSetTextColor [1,1,1,_leftAlpha];
    (_pics#0) ctrlCommit 0;

    (_pics#1) ctrlSetTextColor [1,1,1,_rightAlpha];
    (_pics#1) ctrlCommit 0;

    uiNamespace setVariable [
        "ZuluFX_binoGateAlpha",
        [_leftAlpha,_rightAlpha]
    ];
};

true
