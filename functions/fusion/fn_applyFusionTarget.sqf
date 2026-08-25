params [["_obj",objNull,[objNull]]];

if (isNull _obj || {!alive _obj}) exitWith {false};
if ((count (_obj getVariable ["ZuluFX_fusionData",[]]))>0) exitWith {true};

private _modeData=[] call ZuluFX_fnc_getFusionModeData;
_modeData params ["_mode","_range","_fov","_manMaterial","_vehicleMaterial","_faceClass"];

private _isMan=_obj isKindOf "Man";
private _material=if (_isMan) then {_manMaterial} else {_vehicleMaterial};
private _selections=[_obj] call ZuluFX_fnc_getFusionSelections;
private _current=getObjectMaterials _obj;
private _saved=[];

{
    private _index=_x;
    private _oldMaterial=_current param [_index,""];
    _saved pushBack [_index,_oldMaterial];
    _obj setObjectMaterial [_index,_material];
} forEach _selections;

private _faceData=[];

if (_isMan && {_faceClass!=""}) then {
    private _oldFace=face _obj;
    _obj setFace _faceClass;
    _faceData=[_oldFace,_faceClass];
};

if ((count _saved)==0 && {(count _faceData)==0}) exitWith {false};

_obj setVariable ["ZuluFX_fusionData",[_saved,_faceData]];
true
