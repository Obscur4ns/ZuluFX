[
    "ZuluFX_settingBatteryEnabled",
    "CHECKBOX",
    ["Enable Battery System","Enable ZuluFX NVG battery drain, depletion and replacement."],
    ["ZuluFX","Battery System"],
    true,
    1
] call CBA_fnc_addSetting;

[
    "ZuluFX_settingBatteryLifeKestrel",
    "SLIDER",
    ["Kestrel Battery Life","Base operating time in hours for a standard Kestrel battery load."],
    ["ZuluFX","Battery System"],
    [1,100,16,1],
    1
] call CBA_fnc_addSetting;

[
    "ZuluFX_settingBatteryLifeBNVDF",
    "SLIDER",
    ["BNVD-F Battery Life","Operating time in hours for a full BNVD-F battery pack."],
    ["ZuluFX","Battery System"],
    [1,100,16,1],
    1
] call CBA_fnc_addSetting;

[
    "ZuluFX_settingBatteryLifeGPNVG",
    "SLIDER",
    ["GPNVG Battery Life","Operating time in hours for a full GPNVG battery pack."],
    ["ZuluFX","Battery System"],
    [1,100,30,1],
    1
] call CBA_fnc_addSetting;

[
    "ZuluFX_settingBatteryFusionDrainMultiplier",
    "SLIDER",
    ["Fusion Drain Multiplier","Battery drain multiplier while ZuluFX Fusion is actively running."],
    ["ZuluFX","Battery System"],
    [1,10,2,1],
    1
] call CBA_fnc_addSetting;
