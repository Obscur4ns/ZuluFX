if (!hasInterface) exitWith {false};
disableSerialization;

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {false};

private _border=_display displayCtrl 1001;
if (!isNull _border) then {_border ctrlShow false};

private _res=getResolution;
private _aspect=(_res#4) max 0.1;
private _fovTop=(_res#6) max 0.01;

private _tubeFov=missionNamespace getVariable ["ZuluFX_binoTubeFov",40];
private _apertureFracY=missionNamespace getVariable ["ZuluFX_binoApertureFracY",0.38];
private _maskAlpha=missionNamespace getVariable ["ZuluFX_binoMaskAlpha",0.95];
private _edgeAlpha=missionNamespace getVariable ["ZuluFX_binoEdgeAlpha",0.90];
private _edgeFade=missionNamespace getVariable ["ZuluFX_binoEdgeFade",0.01];
private _texture=missionNamespace getVariable ["ZuluFX_binoOverlayTexture","\ZuluFX\data\overlay\bino_ca.paa"];

_apertureFracY=(_apertureFracY max 0.01) min 1;
_maskAlpha=(_maskAlpha max 0) min 1;
_edgeAlpha=(_edgeAlpha max 0) min 1;
_edgeFade=(_edgeFade max 0) min 1;

private _tubeScreenFrac=(tan (_tubeFov/2))/_fovTop;
private _controlScale=_tubeScreenFrac/_apertureFracY;

private _screenX=safeZoneXAbs;
private _screenY=safeZoneY;
private _screenW=safeZoneWAbs;
private _screenH=safeZoneH;
private _screenR=_screenX+_screenW;
private _screenB=_screenY+_screenH;

private _h=_screenH*_controlScale;
private _w=(_screenW/_aspect)*_controlScale;
private _x=_screenX+((_screenW-_w)*0.5);
private _y=_screenY+((_screenH-_h)*0.5);
private _r=_x+_w;
private _b=_y+_h;

private _pos=[_x,_y,_w,_h];

private _edgePos=[
    [_screenX,_screenY,(_x-_screenX) max 0,_screenH],
    [_r,_screenY,(_screenR-_r) max 0,_screenH],
    [_x,_screenY,_w,(_y-_screenY) max 0],
    [_x,_b,_w,(_screenB-_b) max 0]
];

private _apertureX=missionNamespace getVariable ["ZuluFX_binoApertureX",0.2735];
private _apertureY=missionNamespace getVariable ["ZuluFX_binoApertureY",0.2570];
private _apertureW=missionNamespace getVariable ["ZuluFX_binoApertureW",0.4530];
private _apertureH=missionNamespace getVariable ["ZuluFX_binoApertureH",0.4860];

private _aperturePos=[
    _x+(_w*_apertureX),
    _y+(_h*_apertureY),
    _w*_apertureW,
    _h*_apertureH
];

private _signature=[
    _res#0,
    _res#1,
    _aspect,
    _fovTop,
    _x,
    _y,
    _w,
    _h,
    _maskAlpha,
    _edgeAlpha,
    _edgeFade,
    _aperturePos
];

private _mask=uiNamespace getVariable ["ZuluFX_binoOverlayPicture",controlNull];
private _edges=uiNamespace getVariable ["ZuluFX_binoOverlayEdges",[]];
private _pics=uiNamespace getVariable ["ZuluFX_binoGatePictures",[]];

private _validMask=!isNull _mask;
private _validEdges=(count _edges)==4 && {(_edges findIf {isNull _x})<0};
private _validPics=(count _pics)==2 && {(_pics findIf {isNull _x})<0};

if (_validMask && {_validEdges} && {_validPics}) exitWith {
    private _oldSignature=uiNamespace getVariable ["ZuluFX_binoRenderSignature",[]];

    if !(_signature isEqualTo _oldSignature) then {
        _mask ctrlSetPosition _pos;
        _mask ctrlSetTextColor [1,1,1,_maskAlpha];
        _mask ctrlCommit 0;

        for "_i" from 0 to 3 do {
            private _ctrl=_edges#_i;
            _ctrl ctrlSetPosition (_edgePos#_i);
            _ctrl ctrlSetBackgroundColor [0,0,0,_edgeAlpha];
            _ctrl ctrlSetFade _edgeFade;
            _ctrl ctrlShow true;
            _ctrl ctrlCommit 0;
        };

        {
            _x ctrlSetPosition _pos;
            _x ctrlCommit 0;
        } forEach _pics;

        uiNamespace setVariable ["ZuluFX_binoGatePosition",_pos];
        uiNamespace setVariable ["ZuluFX_binoAperturePosition",_aperturePos];
        uiNamespace setVariable ["ZuluFX_binoRenderSignature",_signature];
    };

    true
};

if (!isNull _mask) then {ctrlDelete _mask};
{if (!isNull _x) then {ctrlDelete _x}} forEach _edges;
{if (!isNull _x) then {ctrlDelete _x}} forEach _pics;

private _newEdges=[];

{
    private _ctrl=_display ctrlCreate ["RscText",-1];
    _ctrl ctrlSetBackgroundColor [0,0,0,_edgeAlpha];
    _ctrl ctrlSetPosition _x;
    _ctrl ctrlSetFade _edgeFade;
    _ctrl ctrlShow true;
    _ctrl ctrlEnable false;
    _ctrl ctrlCommit 0;
    _newEdges pushBack _ctrl;
} forEach _edgePos;

private _newMask=_display ctrlCreate ["RscPicture",-1];
_newMask ctrlSetText _texture;
_newMask ctrlSetPosition _pos;
_newMask ctrlSetTextColor [1,1,1,_maskAlpha];
_newMask ctrlEnable false;
_newMask ctrlCommit 0;

private _gateTextures=[
    "\ZuluFX\data\gating\bino_gate_left_ca.paa",
    "\ZuluFX\data\gating\bino_gate_right_ca.paa"
];

private _newPics=[];

{
    private _ctrl=_display ctrlCreate ["RscPicture",-1];
    _ctrl ctrlSetText _x;
    _ctrl ctrlSetPosition _pos;
    _ctrl ctrlSetTextColor [1,1,1,0];
    _ctrl ctrlEnable false;
    _ctrl ctrlCommit 0;
    _newPics pushBack _ctrl;
} forEach _gateTextures;

uiNamespace setVariable ["ZuluFX_binoOverlayPicture",_newMask];
uiNamespace setVariable ["ZuluFX_binoOverlayEdges",_newEdges];
uiNamespace setVariable ["ZuluFX_binoGatePictures",_newPics];
uiNamespace setVariable ["ZuluFX_binoGatePosition",_pos];
uiNamespace setVariable ["ZuluFX_binoAperturePosition",_aperturePos];
uiNamespace setVariable ["ZuluFX_binoGateAlpha",[-1,-1]];
uiNamespace setVariable ["ZuluFX_binoRenderSignature",_signature];

ZuluFX_binoRenderFov=_tubeFov;
ZuluFX_binoRenderAperture=_apertureFracY;
ZuluFX_binoRenderScale=_controlScale;

true