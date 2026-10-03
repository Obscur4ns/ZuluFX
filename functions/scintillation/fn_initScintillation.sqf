if (!hasInterface) exitWith {};

if (isNil "ZuluFX_scintillationStrength") then {ZuluFX_scintillationStrength=1};
if (isNil "ZuluFX_scintillationPoolSize") then {ZuluFX_scintillationPoolSize=32};

ZuluFX_scintillationNextUpdate=0;
ZuluFX_scintillationDrive=0;
ZuluFX_scintillationAlpha=0;
ZuluFX_scintillationRate=10;
ZuluFX_scintillationCount=0;
ZuluFX_scintillationColour=[1,1,1];

uiNamespace setVariable ["ZuluFX_scintillationControls",[]];

if (!isNil "ZuluFX_scintillationPFH") then {
    [ZuluFX_scintillationPFH] call CBA_fnc_removePerFrameHandler;
};

ZuluFX_scintillationPFH=[
    {
        [] call ZuluFX_fnc_updateScintillation;
    },
    0.02
] call CBA_fnc_addPerFrameHandler;
