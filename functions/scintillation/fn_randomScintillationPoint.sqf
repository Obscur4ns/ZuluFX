params [["_mode",2,[0]]];

private _centres=[];
private _rx=0.30;
private _ry=0.43;

if (_mode==4) then {
    _centres=[0.20,0.40,0.60,0.80];
    _rx=0.185;
    _ry=0.43;
} else {
    _centres=[0.32,0.68];
};

private _result=[0.5,0.5];

for "_attempt" from 0 to 31 do {
    private _px=random 1;
    private _py=random 1;
    private _inside=false;

    {
        private _dx=(_px-_x)/_rx;
        private _dy=(_py-0.5)/_ry;

        if (((_dx*_dx)+(_dy*_dy))<=1) exitWith {
            _inside=true;
        };
    } forEach _centres;

    if (_inside) exitWith {
        _result=[_px,_py];
    };
};

_result
