if (isDedicated) exitWith {};

["ZuluFX_settingPhosphor","LIST",["Phosphor","Select the phosphor simulation. Native leaves ACE/Fawks colour control untouched."],["ZuluFX","Night Vision Colour"],[["NATIVE","P45","P43","P11","P22R","CUSTOM"],["Native / ACE / Fawks","P45 White","P43 Green","P11 Blue","P22R Red","Custom"],1],false,{
    ZuluFX_phosphorProfile=_this;
    if (missionNamespace getVariable ["ZuluFX_nvgActive",false]) then {[true,_this] call ZuluFX_fnc_setPhosphor};
}] call CBA_fnc_addSetting;

["ZuluFX_settingCustomColour","COLOR",["Custom Phosphor Colour","Colour used when Phosphor is set to Custom."],["ZuluFX","Night Vision Colour"],[1,1,1],false,{
    ZuluFX_customPhosphorColour=_this;
    if ((missionNamespace getVariable ["ZuluFX_nvgActive",false]) && {(missionNamespace getVariable ["ZuluFX_phosphorProfile","P45"])=="CUSTOM"}) then {[true,"CUSTOM"] call ZuluFX_fnc_setPhosphor};
}] call CBA_fnc_addSetting;

["ZuluFX_settingCustomBrightness","SLIDER",["Custom Phosphor Brightness","Brightness used when Phosphor is set to Custom."],["ZuluFX","Night Vision Colour"],[0.50,1.50,1.12,2],false,{
    ZuluFX_customPhosphorBrightness=_this;
    if ((missionNamespace getVariable ["ZuluFX_nvgActive",false]) && {(missionNamespace getVariable ["ZuluFX_phosphorProfile","P45"])=="CUSTOM"}) then {[true,"CUSTOM"] call ZuluFX_fnc_setPhosphor};
}] call CBA_fnc_addSetting;

["ZuluFX_settingOutputFilter","LIST",["Output Filter","Optional optical filter applied after the selected phosphor."],["ZuluFX","Night Vision Colour"],[["NONE","AMBER","ONYX"],["None","Clear Amber","Nocturn Onyx"],0],false,{
    ZuluFX_outputFilter=_this;
    if (missionNamespace getVariable ["ZuluFX_nvgActive",false]) then {[true,_this] call ZuluFX_fnc_setOutputFilter};
}] call CBA_fnc_addSetting;