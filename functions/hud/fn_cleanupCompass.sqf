if (!hasInterface) exitWith {false};

if (!isNil "ZuluFX_compassPFH") then {
    [ZuluFX_compassPFH] call CBA_fnc_removePerFrameHandler;
    ZuluFX_compassPFH=nil;
};

disableSerialization;

private _old=uiNamespace getVariable [
    "ZuluFX_compassControl",
    controlNull
];

if (!isNull _old) then {
    ctrlDelete _old;
};

{
    if (!isNull _x) then {
        ctrlDelete _x;
    };
} forEach (
    uiNamespace getVariable [
        "ZuluFX_compassTicks",
        []
    ]
);

{
    if (!isNull _x) then {
        ctrlDelete _x;
    };
} forEach (
    uiNamespace getVariable [
        "ZuluFX_compassLabels",
        []
    ]
);

private _centre=uiNamespace getVariable [
    "ZuluFX_compassCentre",
    controlNull
];

if (!isNull _centre) then {
    ctrlDelete _centre;
};

private _heading=uiNamespace getVariable [
    "ZuluFX_compassHeading",
    controlNull
];

if (!isNull _heading) then {
    ctrlDelete _heading;
};

uiNamespace setVariable ["ZuluFX_compassControl",controlNull];
uiNamespace setVariable ["ZuluFX_compassTicks",[]];
uiNamespace setVariable ["ZuluFX_compassLabels",[]];
uiNamespace setVariable ["ZuluFX_compassCentre",controlNull];
uiNamespace setVariable ["ZuluFX_compassHeading",controlNull];

true