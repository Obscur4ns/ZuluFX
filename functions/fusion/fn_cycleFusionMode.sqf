if (!hasInterface || {isNull player}) exitWith {false};

private _item=hmd player;
if ((missionNamespace getVariable ["ZuluFX_nvgClass",""]) isNotEqualTo _item) then {
    [true,false] call ZuluFX_fnc_updateNVGProfile;
};

if !(missionNamespace getVariable ["ZuluFX_nvgFusionCapable",false]) exitWith {false};

private _modes=missionNamespace getVariable ["ZuluFX_nvgFusionModes",[]];
if ((count _modes)<2) exitWith {false};

private _current=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode",missionNamespace getVariable ["ZuluFX_nvgFusionDefaultMode","PATROL"]]);
private _index=_modes find _current;
if (_index<0) then {_index=0};

private _next=_modes#((_index+1) mod (count _modes));
[_next,true] call ZuluFX_fnc_setFusionMode
