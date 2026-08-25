if (!hasInterface) exitWith {false};

ZuluFX_nvgProfile=createHashMap;
ZuluFX_nvgClass="";
ZuluFX_nvgSupported=false;
ZuluFX_nvgTubeMode=0;
ZuluFX_nvgFusionCapable=false;
ZuluFX_nvgFusionFOV=30;
ZuluFX_nvgFusionModes=[];
ZuluFX_nvgFusionDefaultMode="PATROL";
ZuluFX_nvgFusionPatrolRange=500;
ZuluFX_nvgFusionOutlineRange=300;
ZuluFX_nvgFusionMaxRange=500;
ZuluFX_nvgCompassCapable=false;
ZuluFX_nvgCompassAnchor=[0.5,0.15];
ZuluFX_nvgHUDMode="NONE";
ZuluFX_nvgBatteryIndicator="NONE";
ZuluFX_nvgBatteryIndicatorAnchor=[0.5,0.5];

ZuluFX_fusionMode="PATROL";
ZuluFX_fusionActive=false;
ZuluFX_fusionCandidates=[];
ZuluFX_fusionTargets=[];
ZuluFX_fusionVisionState=0;
ZuluFX_fusionCyclePending=-1;
ZuluFX_fusionReentry=false;

["loadout",{
    [false,false] call ZuluFX_fnc_updateNVGProfile;
},true] call CBA_fnc_addPlayerEventHandler;

true
