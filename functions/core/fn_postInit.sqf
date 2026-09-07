if (!hasInterface) exitWith {};

call ZuluFX_fnc_createEffects;

["visionMode",{
    _this call ZuluFX_fnc_handleVisionMode;
},true] call CBA_fnc_addPlayerEventHandler;

["cameraView",{
    params ["_unit","_cameraView"];

    if (_unit isNotEqualTo player) exitWith {};
    if !(missionNamespace getVariable ["ZuluFX_nvgActive",false]) exitWith {};

    [{
        if !(missionNamespace getVariable ["ZuluFX_nvgActive",false]) exitWith {};

        private _phosphor=missionNamespace getVariable [
            "ZuluFX_phosphorProfile",
            missionNamespace getVariable ["ZuluFX_settingPhosphor","P45"]
        ];

        private _filter=missionNamespace getVariable [
            "ZuluFX_outputFilter",
            missionNamespace getVariable ["ZuluFX_settingOutputFilter","NONE"]
        ];

        [true,_phosphor] call ZuluFX_fnc_setPhosphor;
        [true,_filter] call ZuluFX_fnc_setOutputFilter;
    }] call CBA_fnc_execNextFrame;
},true] call CBA_fnc_addPlayerEventHandler;

call ZuluFX_fnc_startEnvironmentLoop;
call ZuluFX_fnc_startGrainLoop;
call ZuluFX_fnc_startGainLoop;
call ZuluFX_fnc_startGatingLoop;

ZuluFX_initialized=true;
