if (!hasInterface || {isNull player} || {!alive player}) exitWith {false};

private _item=hmd player;
if (_item=="") exitWith {false};

if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgCompassCapable",false]) exitWith {false};
if !(call ZuluFX_fnc_isNVGActive) exitWith {false};
if !(missionNamespace getVariable ["ZuluFX_compassEnabled",true]) exitWith {false};
if (!isNull findDisplay 312) exitWith {false};
if (!isNull findDisplay 177) exitWith {false};

true