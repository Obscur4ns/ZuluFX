if (!hasInterface) exitWith {false};
if !(missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {false};

if !([] call ZuluFX_fnc_canUseFusion) exitWith {
    [] call ZuluFX_fnc_cleanupFusion;
    false
};

private _modeData=[] call ZuluFX_fnc_getFusionModeData;
_modeData params ["_mode","_range","_fov"];

private _cameraPos=positionCameraToWorld [0,0,0];
private _cameraDir=getCameraViewDirection player;
private _halfFOV=_fov*0.5;
private _hysteresis=2;

private _candidates=missionNamespace getVariable ["ZuluFX_fusionCandidates",[]];
if !(_candidates isEqualType []) then {_candidates=[]};

private _old=missionNamespace getVariable ["ZuluFX_fusionTargets",[]];
if !(_old isEqualType []) then {_old=[]};

private _near=[];

{
    private _obj=_x;

    if (
        _obj isEqualType objNull &&
        {!isNull _obj} &&
        {_obj isNotEqualTo player} &&
        {alive _obj}
    ) then {
        private _bounds=_obj getVariable ["ZuluFX_fusionBounds",[]];
        if !(_bounds isEqualType []) then {_bounds=[]};

        if ((count _bounds)<3) then {
            private _box=0 boundingBoxReal _obj;
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

            _bounds=[_center,_radius max 0.25,_samples];
            _obj setVariable ["ZuluFX_fusionBounds",_bounds];
        };

        _bounds params ["_centerModel","_radius","_samples"];

        private _targetPos=_obj modelToWorldVisual _centerModel;
        private _toTarget=_targetPos vectorDiff _cameraPos;
        private _distance=vectorMagnitude _toTarget;

        if ((_distance-_radius)<=_range) then {
            private _active=(_old find _obj)>=0;
            private _limit=_halfFOV+(if (_active) then {_hysteresis} else {0});
            private _include=false;

            if (_distance<=(_radius max 0.01)) then {
                _include=true;
            } else {
                private _targetDir=_toTarget vectorMultiply (1/_distance);
                private _centerDot=_cameraDir vectorDotProduct _targetDir;
                private _angularRadius=asin ((_radius/_distance) min 1);
                private _inner=(_limit-_angularRadius) max 0;
                private _outer=(_limit+_angularRadius) min 179;

                if (_centerDot>=cos _inner) then {
                    _include=true;
                } else {
                    if (_centerDot>=cos _outer) then {
                        {
                            private _samplePos=_obj modelToWorldVisual _x;
                            private _sampleVector=_samplePos vectorDiff _cameraPos;
                            private _sampleDistance=vectorMagnitude _sampleVector;

                            if (_sampleDistance>0.01) then {
                                private _sampleDir=_sampleVector vectorMultiply (1/_sampleDistance);

                                if ((_cameraDir vectorDotProduct _sampleDir)>=cos _limit) exitWith {
                                    _include=true;
                                };
                            };
                        } forEach _samples;
                    };
                };
            };

            if (_include) then {
                _near pushBack _obj;
            };
        };
    };
} forEach _candidates;

{
    private _obj=_x;

    if (
        _obj isEqualType objNull &&
        {!isNull _obj} &&
        {(_near find _obj)<0}
    ) then {
        [_obj] call ZuluFX_fnc_restoreFusionTarget;
    };
} forEach _old;

private _next=[];

{
    private _obj=_x;

    if ((_old find _obj)<0) then {
        [_obj] call ZuluFX_fnc_applyFusionTarget;
    };

    if ((count (_obj getVariable ["ZuluFX_fusionData",[]]))>0) then {
        _next pushBack _obj;
    };
} forEach _near;

ZuluFX_fusionTargets=_next;
true
