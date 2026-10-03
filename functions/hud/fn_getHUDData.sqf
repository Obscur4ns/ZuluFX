if (!hasInterface || {isNull player}) exitWith {createHashMap};

private _cache=missionNamespace getVariable ["ZuluFX_hudDataCache",createHashMap];
private _now=diag_tickTime;
private _next=missionNamespace getVariable ["ZuluFX_hudDataNextUpdate",0];

if (_now>=_next || {(count _cache)==0}) then {
    private _raw=mapGridPosition player;
    private _grid=_raw;
    private _len=count _raw;

    if (_len>=6 && {(_len mod 2)==0}) then {
        private _half=_len/2;
        private _east=_raw select [0,3 min _half];
        private _north=_raw select [_half,3 min (_len-_half)];
        _grid=format ["%1 %2",_east,_north];
    };

    private _alt=round ((getPosASL player)#2);
    private _d=date;
    private _hour=_d#3;
    private _minute=_d#4;
    private _hh=if (_hour<10) then {"0"+str _hour} else {str _hour};
    private _mm=if (_minute<10) then {"0"+str _minute} else {str _minute};

    _cache set ["location",_grid];
    _cache set ["altitude",format ["%1m",_alt]];
    _cache set ["time",_hh+_mm];

    ZuluFX_hudDataNextUpdate=_now+0.25;
};

private _fusion="";
if (
    missionNamespace getVariable ["ZuluFX_fusionActive",false] &&
    {(missionNamespace getVariable ["ZuluFX_fusionVisionState",0])==2}
) then {
    _fusion=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);
};

_cache set ["fusion",_fusion];
ZuluFX_hudDataCache=_cache;
_cache
