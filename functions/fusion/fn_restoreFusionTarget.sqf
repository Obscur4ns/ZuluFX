params [["_obj",objNull,[objNull]]];

if (isNull _obj) exitWith {false};

private _data=_obj getVariable ["ZuluFX_fusionData",[]];
if ((count _data)<2) exitWith {
    _obj setVariable ["ZuluFX_fusionData",nil];
    false
};

_data params ["_materials","_faceData"];

{
    _x params ["_index","_oldMaterial"];

    _obj setObjectMaterial [_index,"#reset"];

    if (_oldMaterial!="") then {
        _obj setObjectMaterial [_index,_oldMaterial];
    };
} forEach _materials;

if ((count _faceData)==2) then {
    _faceData params ["_oldFace","_appliedFace"];
    _obj setFace _oldFace;
};

_obj setVariable ["ZuluFX_fusionData",nil];
true
