if (!hasInterface) exitWith {false};
if !(missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {false};

private _range=missionNamespace getVariable ["ZuluFX_nvgFusionMaxRange",500];
private _origin=cameraOn;
if (isNull _origin) then {_origin=player};

private _candidates=_origin nearEntities [
    [
        "Man",
        "LandVehicle",
        "Air",
        "Ship"
    ],
    _range
];

_candidates=_candidates select {
    !isNull _x &&
    {_x isNotEqualTo player} &&
    {alive _x}
};

{
    private _box=0 boundingBoxReal _x;
    private _min=_box param [0,[0,0,0]];
    private _max=_box param [1,[0,0,0]];

    private _mx=((_min#0)+(_max#0))*0.5;
    private _my=((_min#1)+(_max#1))*0.5;
    private _mz=((_min#2)+(_max#2))*0.5;

    private _center=[_mx,_my,_mz];
    private _radius=(vectorMagnitude (_max vectorDiff _min))*0.5;

    private _samples=[
        _center,
        [_min#0,_min#1,_min#2],
        [_min#0,_min#1,_max#2],
        [_min#0,_max#1,_min#2],
        [_min#0,_max#1,_max#2],
        [_max#0,_min#1,_min#2],
        [_max#0,_min#1,_max#2],
        [_max#0,_max#1,_min#2],
        [_max#0,_max#1,_max#2],
        [_mx,_min#1,_mz],
        [_mx,_max#1,_mz],
        [_min#0,_my,_mz],
        [_max#0,_my,_mz],
        [_mx,_my,_min#2],
        [_mx,_my,_max#2]
    ];

    _x setVariable [
        "ZuluFX_fusionBounds",
        [_center,_radius max 0.25,_samples]
    ];
} forEach _candidates;

ZuluFX_fusionCandidates=_candidates;
true
