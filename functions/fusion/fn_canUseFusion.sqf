if (!hasInterface || {isNull player} || {!alive player}) exitWith {false};

private _item=hmd player;
if (_item=="") exitWith {false};

if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]) exitWith {false};
if ((count (missionNamespace getVariable ["ZuluFX_nvgFusionModes",[]]))==0) exitWith {false};
if !(call ZuluFX_fnc_isNVGActive) exitWith {false};

true
