if (!hasInterface) exitWith {};

private _pp=missionNamespace getVariable ["ZuluFX_ppDOF",-1];
if (_pp<0) then {_pp=call ZuluFX_fnc_createDOF};
if (_pp<0) exitWith {};

private _active=missionNamespace getVariable ["ZuluFX_nvgActive",false];
if (!_active) exitWith {
    _pp ppEffectEnable false;
    ZuluFX_dofFocus=-1;
    ZuluFX_dofTarget=-1;
    ZuluFX_dofRenderFocus=5;
    ZuluFX_dofBlur=1;
    ZuluFX_dofLastUpdate=diag_tickTime;
};

private _now=diag_tickTime;
private _last=missionNamespace getVariable ["ZuluFX_dofLastUpdate",_now];
private _dt=(_now-_last) max 0;
if (_dt>0.2) then {_dt=0.2};
ZuluFX_dofLastUpdate=_now;

private _maxDist=250;
private _radius=0.03;
private _start=AGLToASL positionCameraToWorld [0,0,0];
private _samples=[];

{
    _x params ["_ox","_oy"];
    private _aim=AGLToASL positionCameraToWorld [_ox,_oy,1];
    private _dir=_aim vectorDiff _start;
    private _mag=vectorMagnitude _dir;
    if (_mag>0.001) then {
        _dir=_dir vectorMultiply (1/_mag);
        private _end=_start vectorAdd (_dir vectorMultiply _maxDist);
        private _hits=lineIntersectsSurfaces [_start,_end,vehicle player,objNull,true,1,"VIEW","FIRE"];
        private _d=_maxDist;
        if !(_hits isEqualTo []) then {_d=_start distance ((_hits select 0) select 0)};
        _d=(_d max 0.6) min _maxDist;
        _samples pushBack _d;
    };
} forEach [[0,0],[-_radius,0],[_radius,0],[0,-_radius],[0,_radius]];

if ((count _samples)!=5) exitWith {};

private _centre=_samples select 0;
private _weighted=[_centre,_centre,_centre,_samples select 1,_samples select 2,_samples select 3,_samples select 4];
_weighted sort true;
private _candidate=_weighted select 3;

private _target=missionNamespace getVariable ["ZuluFX_dofTarget",-1];
private _focus=missionNamespace getVariable ["ZuluFX_dofFocus",-1];
private _renderFocus=missionNamespace getVariable ["ZuluFX_dofRenderFocus",5];
private _blur=missionNamespace getVariable ["ZuluFX_dofBlur",1];

if (_target<0) then {_target=_candidate};
if (_focus<0) then {_focus=_candidate};

private _deadband=0.45 max (_target*0.14);
if ((abs (_candidate-_target))>_deadband) then {_target=_candidate};

private _tau=0.36;
if (_target<_focus) then {_tau=0.20};
private _k=1-exp (-_dt/_tau);
_focus=_focus+((_target-_focus)*_k);
_focus=(_focus max 0.6) min _maxDist;

private _renderTarget=_focus max 5;
private _baseBlur=3.05;

if (_focus<5) then {
    _baseBlur=linearConversion [0.6,5,_focus,0.60,1.55,true];
} else {
    if (_focus<7.5) then {
        _baseBlur=linearConversion [5,7.5,_focus,1.55,2.50,true];
    } else {
        if (_focus<10) then {
            _baseBlur=linearConversion [7.5,10,_focus,2.50,4.10,true];
        } else {
            if (_focus<30) then {
                _baseBlur=linearConversion [10,30,_focus,4.10,3.65,true];
            } else {
                if (_focus<80) then {
                    _baseBlur=linearConversion [30,80,_focus,3.65,3.25,true];
                } else {
                    _baseBlur=linearConversion [80,160,_focus,3.25,3.05,true];
                };
            };
        };
    };
};

private _strength=missionNamespace getVariable ["ZuluFX_dofStrength",1.25];
_baseBlur=_baseBlur*_strength;

private _renderK=1-exp (-_dt/0.24);
_renderFocus=_renderFocus+((_renderTarget-_renderFocus)*_renderK);
_renderFocus=(_renderFocus max 5) min _maxDist;

private _relMove=(abs (_target-_focus))/(_focus max 1);
private _move=linearConversion [0.025,0.45,_relMove,0,1,true];
private _moveEase=_move*_move*(3-(2*_move));
private _blurTarget=_baseBlur*(1-(0.35*_moveEase));
if (_blurTarget<0.30) then {_blurTarget=0.30};

private _blurK=1-exp (-_dt/0.24);
_blur=_blur+((_blurTarget-_blur)*_blurK);

ZuluFX_dofCandidate=_candidate;
ZuluFX_dofTarget=_target;
ZuluFX_dofFocus=_focus;
ZuluFX_dofRenderFocus=_renderFocus;
ZuluFX_dofBlur=_blur;
ZuluFX_dofMove=_move;
ZuluFX_dofSamples=_samples;

_pp ppEffectAdjust [1,_renderFocus,_blur];
_pp ppEffectCommit 0;
_pp ppEffectEnable true;
