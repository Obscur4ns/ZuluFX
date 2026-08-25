if (!hasInterface || {isNull player}) exitWith {createHashMap};

private _cache=missionNamespace getVariable ["ZuluFX_hudDataCache",createHashMap];
private _now=diag_tickTime;
private _next=missionNamespace getVariable ["ZuluFX_hudDataNextUpdate",0];

if (_now>=_next || {(count _cache)==0}) then {
    private _gridRaw=mapGridPosition player;
    private _grid=_gridRaw;
    private _len=count _gridRaw;

    if (_len>=6 && {(_len mod 2)==0}) then {
        private _half=_len/2;
        private _east=_gridRaw select [0,3 min _half];
        private _north=_gridRaw select [_half,3 min (_len-_half)];
        _grid=format ["%1 %2",_east,_north];
    };

    private _altitude=round ((getPosASL player)#2);

    private _date=date;
    private _hour=_date#3;
    private _minute=_date#4;

    private _hh=if (_hour<10) then {"0"+str _hour} else {str _hour};
    private _mm=if (_minute<10) then {"0"+str _minute} else {str _minute};

    _cache set ["location",_grid];
    _cache set ["altitude",format ["%1m",_altitude]];
    _cache set ["time",_hh+_mm];

    missionNamespace setVariable ["ZuluFX_hudDataNextUpdate",_now+0.20];
};

private _fusion="";
if (
    missionNamespace getVariable ["ZuluFX_fusionActive",false] &&
    {(missionNamespace getVariable ["ZuluFX_fusionVisionState",0])==2}
) then {
    _fusion=toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]);
};

_cache set ["fusion",_fusion];
missionNamespace setVariable ["ZuluFX_hudDataCache",_cache];

_cache
