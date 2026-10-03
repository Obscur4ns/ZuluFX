if (!hasInterface) exitWith {};

private _pics=uiNamespace getVariable ["ZuluFX_quadGatePictures",[]];

if (!ZuluFX_nvgActive) exitWith {
    {if (!isNull _x) then {_x ctrlSetTextColor [1,1,1,0]}} forEach _pics;
    uiNamespace setVariable ["ZuluFX_quadGateAlpha",[0,0,0,0]];
};

if (!(call ZuluFX_fnc_createQuadRenderer)) exitWith {};
_pics=uiNamespace getVariable ["ZuluFX_quadGatePictures",[]];
if ((count _pics)!=4) exitWith {};

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {};
private _border=_display displayCtrl 1001;
if (isNull _border) exitWith {};

private _pos=ctrlPosition _border;
private _lastPos=uiNamespace getVariable ["ZuluFX_quadGatePosition",[]];

if !(_pos isEqualTo _lastPos) then {
    {_x ctrlSetPosition _pos;_x ctrlCommit 0} forEach _pics;
    uiNamespace setVariable ["ZuluFX_quadGatePosition",_pos];
};

private _values=missionNamespace getVariable ["ZuluFX_quadResiduals",[0,0,0,0]];
private _strength=missionNamespace getVariable ["ZuluFX_gatingLocalStrength",0.80];
_strength=(_strength max 0) min 1;

private _last=uiNamespace getVariable ["ZuluFX_quadGateAlpha",[-1,-1,-1,-1]];
private _eps=0.002;

for "_i" from 0 to 3 do {
    private _ctrl=_pics select _i;
    private _value=(_values select _i)*_strength;
    if (!isNull _ctrl && {abs(_value-(_last select _i))>_eps}) then {
        _ctrl ctrlSetTextColor [1,1,1,_value];
        _last set [_i,_value];
    };
};

uiNamespace setVariable ["ZuluFX_quadGateAlpha",_last];