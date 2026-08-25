params [["_type","",[""]]];
if (_type isEqualTo "") exitWith {0};

private _cache = missionNamespace getVariable ["ZuluFX_explosionPowerCache",createHashMap];
private _cached = _cache getOrDefault [_type,-1];
if (_cached >= 0) exitWith {_cached};

private _cfg = configFile >> "CfgAmmo" >> _type;
private _power = 0;

if (isClass _cfg) then {
    private _lower = toLower _type;
    private _effects = toLower getText (_cfg >> "explosionEffects");
    private _keys = ["flash","m84","stun","6bang","6_bang","sixbang","diversion"];
    private _flash = false;

    {
        if (_lower find _x >= 0 || {_effects find _x >= 0}) exitWith {_flash = true};
    } forEach _keys;

    if (_flash) then {
        _power = 300;
    } else {
        private _indirect = getNumber (_cfg >> "indirectHit");
        if (_indirect >= 3) then {_power = (60 + (_indirect * 2)) min 200};
    };
};

_cache set [_type,_power];
ZuluFX_explosionPowerCache = _cache;
_power