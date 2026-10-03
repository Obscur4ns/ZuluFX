params ["_mode",["_list",[]]];

if (_mode=="set") exitWith {
    uiNamespace setVariable ["ZuluFX_fusionOutlineSegments",_list];
    true
};

uiNamespace setVariable ["ZuluFX_fusionOutlineSegments",[]];

private _map=uiNamespace getVariable ["ZuluFX_fusionCanvas",controlNull];
if (isNull _map) exitWith {[]};

private _ready=uiNamespace getVariable ["ZuluFX_fusionCanvasReadyFrame",diag_frameNo];
if (diag_frameNo<(_ready+2)) exitWith {[]};

if ((ctrlFade _map)>0) then {
    _map ctrlSetFade 0;
    _map ctrlCommit 0;
};

if (_mode=="clear") exitWith {[]};

private _o=_map ctrlMapScreenToWorld [0.5,0.5];
private _pX=_map ctrlMapScreenToWorld [0.6,0.5];
private _pY=_map ctrlMapScreenToWorld [0.5,0.6];

if (
    (count _o)<2 ||
    {(count _pX)<2} ||
    {(count _pY)<2}
) exitWith {[]};

private _kx=((_pX#0)-(_o#0))/0.1;
private _ky=((_pY#1)-(_o#1))/0.1;

if ((abs _kx)<1e-6 || {(abs _ky)<1e-6}) exitWith {[]};

[
    (_o#0)-(0.5*_kx),
    (_o#1)-(0.5*_ky),
    _kx,
    _ky,
    _map
]