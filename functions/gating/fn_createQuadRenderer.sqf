if (!hasInterface) exitWith {false};
disableSerialization;

private _display=uiNamespace getVariable ["ace_nightvision_titleDisplay",displayNull];
if (isNull _display) exitWith {false};

private _border=_display displayCtrl 1001;
if (!isNull _border) then {_border ctrlShow false};

private _res=getResolution;
private _aspect=(_res#4) max 0.1;
private _fovTop=(_res#6) max 0.01;

private _verticalFov=missionNamespace getVariable ["ZuluFX_quadVerticalFov",48.5];
private _apertureFracX=missionNamespace getVariable ["ZuluFX_quadApertureFracX",1306/2048];
private _apertureFracY=missionNamespace getVariable ["ZuluFX_quadApertureFracY",520/2048];
private _maskAlpha=missionNamespace getVariable ["ZuluFX_quadMaskAlpha",0.95];
private _edgeAlpha=missionNamespace getVariable ["ZuluFX_quadEdgeAlpha",0.90];
private _texture=missionNamespace getVariable ["ZuluFX_quadOverlayTexture","\ZuluFX\data\overlay\quad_ca.paa"];

_apertureFracX=(_apertureFracX max 0.01) min 1;
_apertureFracY=(_apertureFracY max 0.01) min 1;
_maskAlpha=(_maskAlpha max 0) min 1;
_edgeAlpha=(_edgeAlpha max 0) min 1;

private _tubeScreenFrac=(tan (_verticalFov/2))/_fovTop;
private _controlScale=_tubeScreenFrac/_apertureFracY;
private _effectiveHorizontalFov=2*atan((tan(_verticalFov/2))*(_apertureFracX/_apertureFracY));

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

private _apertureX=(1-_apertureFracX)*0.5;
private _apertureY=(1-_apertureFracY)*0.5;
private _aperturePos=[
    _x+(_w*_apertureX),
    _y+(_h*_apertureY),
    _w*_apertureFracX,
    _h*_apertureFracY
];

private _clipX=_x max _screenX;
private _clipR=_r min _screenR;
private _clipW=(_clipR-_clipX) max 0;

private _edgePos=[
    [_screenX,_screenY,((_x min _screenR)-_screenX) max 0,_screenH],
    [_r max _screenX,_screenY,(_screenR-(_r max _screenX)) max 0,_screenH],
    [_clipX,_screenY,_clipW,((_y min _screenB)-_screenY) max 0],
    [_clipX,_b max _screenY,_clipW,(_screenB-(_b max _screenY)) max 0]
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
    _verticalFov,
    _apertureFracX,
    _apertureFracY,
    _maskAlpha,
    _edgeAlpha,
    _texture,
    _aperturePos
];

private _mask=uiNamespace getVariable ["ZuluFX_quadOverlayPicture",controlNull];
private _edges=uiNamespace getVariable ["ZuluFX_quadOverlayEdges",[]];
private _validMask=!isNull _mask;
private _validEdges=(count _edges)==4 && {(_edges findIf {isNull _x})<0};

if (_validMask && {_validEdges}) exitWith {
    private _oldSignature=uiNamespace getVariable ["ZuluFX_quadRenderSignature",[]];
    if !(_signature isEqualTo _oldSignature) then {
        _mask ctrlSetText _texture;
        _mask ctrlSetPosition _pos;
        _mask ctrlSetTextColor [1,1,1,_maskAlpha];
        _mask ctrlCommit 0;
        for "_i" from 0 to 3 do {
            private _ctrl=_edges#_i;
            _ctrl ctrlSetPosition (_edgePos#_i);
            _ctrl ctrlSetBackgroundColor [0,0,0,_edgeAlpha];
            _ctrl ctrlCommit 0;
        };
        uiNamespace setVariable ["ZuluFX_quadPosition",_pos];
        uiNamespace setVariable ["ZuluFX_quadAperturePosition",_aperturePos];
        uiNamespace setVariable ["ZuluFX_quadRenderSignature",_signature];
    };
    true
};

if (!isNull _mask) then {ctrlDelete _mask};
{if (!isNull _x) then {ctrlDelete _x}} forEach _edges;

private _newEdges=[];
{
    private _ctrl=_display ctrlCreate ["RscText",-1];
    _ctrl ctrlSetBackgroundColor [0,0,0,_edgeAlpha];
    _ctrl ctrlSetPosition _x;
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

uiNamespace setVariable ["ZuluFX_quadOverlayPicture",_newMask];
uiNamespace setVariable ["ZuluFX_quadOverlayEdges",_newEdges];
uiNamespace setVariable ["ZuluFX_quadPosition",_pos];
uiNamespace setVariable ["ZuluFX_quadAperturePosition",_aperturePos];
uiNamespace setVariable ["ZuluFX_quadRenderSignature",_signature];

ZuluFX_quadRenderVerticalFov=_verticalFov;
ZuluFX_quadRenderHorizontalFov=_effectiveHorizontalFov;
ZuluFX_quadRenderAperture=[_apertureFracX,_apertureFracY];
ZuluFX_quadRenderScale=_controlScale;

true