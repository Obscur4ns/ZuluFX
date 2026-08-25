private _mode=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode",missionNamespace getVariable ["ZuluFX_nvgFusionDefaultMode","PATROL"]]);
private _modes=missionNamespace getVariable ["ZuluFX_nvgFusionModes",["PATROL"]];

if !(_mode in _modes) then {
    _mode=toUpper (missionNamespace getVariable ["ZuluFX_nvgFusionDefaultMode","PATROL"]);
};

private _fov=missionNamespace getVariable ["ZuluFX_nvgFusionFOV",30];
private _range=missionNamespace getVariable ["ZuluFX_nvgFusionPatrolRange",500];
private _manMaterial="\ZuluFX\data\fusion\fusion_softwhite_man.rvmat";
private _vehicleMaterial="\ZuluFX\data\fusion\fusion_softwhite_vehicle.rvmat";
private _face="ZuluFX_FusionFace_SoftWhiteTI";

if (_mode=="OUTLINE") then {
    _range=missionNamespace getVariable ["ZuluFX_nvgFusionOutlineRange",300];
    _manMaterial="\ZuluFX\data\fusion\fusion_outline_man.rvmat";
    _vehicleMaterial="\ZuluFX\data\fusion\fusion_outline_vehicle.rvmat";
    _face="ZuluFX_FusionFace_Outline";
};

[_mode,_range,_fov,_manMaterial,_vehicleMaterial,_face]
