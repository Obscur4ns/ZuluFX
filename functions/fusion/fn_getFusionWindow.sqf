if (!hasInterface) exitWith {[]};

private _res=getResolution;
private _fovTop=(_res param [6,0.75]) max 0.01;
private _fovLeft=(_res param [7,(_fovTop*((_res#0)/((_res#1) max 1)))]) max 0.01;
private _baseViewFov=0.75;

private _fusionFov=(missionNamespace getVariable ["ZuluFX_nvgFusionFOV",30]) max 1 min 120;
private _sensorAspect=(missionNamespace getVariable ["ZuluFX_fusionAspect",4/3]) max 0.5 min 2;

private _tanHalfH=tan (_fusionFov*0.5);
private _tanHalfV=_tanHalfH/_sensorAspect;

private _fracX=(_tanHalfH/(_fovLeft*_baseViewFov)) max 0.01 min 1;
private _fracY=(_tanHalfV/(_fovTop*_baseViewFov)) max 0.01 min 1;

private _w=(round ((safeZoneWAbs*_fracX)/pixelW))*pixelW;
private _h=(round ((safeZoneH*_fracY)/pixelH))*pixelH;
_w=_w max pixelW;
_h=_h max pixelH;

private _cx=safeZoneXAbs+(safeZoneWAbs*0.5);
private _cy=safeZoneY+(safeZoneH*0.5);

private _x=safeZoneXAbs+(round (((_cx-(_w*0.5))-safeZoneXAbs)/pixelW))*pixelW;
private _y=safeZoneY+(round (((_cy-(_h*0.5))-safeZoneY)/pixelH))*pixelH;

[_x,_y,_w,_h]
