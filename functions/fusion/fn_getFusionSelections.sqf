params [["_object",objNull,[objNull]]];

if (isNull _object) exitWith {[]};

private _cfg=configFile >> "CfgVehicles" >> typeOf _object;
if !(isClass _cfg) exitWith {[]};

private _hidden=getArray (_cfg >> "hiddenSelections");
if ((count _hidden)==0) exitWith {[]};

private _custom=getArray (_cfg >> "ZuluFX_fusionSelections");

if ((count _custom)>0) exitWith {
    private _result=[];

    {
        if (_x isEqualType 0) then {
            if (_x>=0 && {_x<count _hidden}) then {
                _result pushBackUnique _x;
            };
        } else {
            private _wanted=toLower _x;
            private _index=_hidden findIf {
                (toLower _x)==_wanted
            };

            if (_index>=0) then {
                _result pushBackUnique _index;
            };
        };
    } forEach _custom;

    _result
};

private _result=[];

{
    private _name=toLower _x;

    if (
        (_name find "mfd")<0 &&
        {(_name find "display")<0} &&
        {(_name find "screen")<0}
    ) then {
        _result pushBack _forEachIndex;
    };
} forEach _hidden;

_result
