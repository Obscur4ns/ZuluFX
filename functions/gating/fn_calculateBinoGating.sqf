private _bino = call ZuluFX_fnc_sampleBino;
private _left = _bino select 0;
private _right = _bino select 1;
[
    (_left / (_left + 1.5)) max 0 min 1,
    (_right / (_right + 1.5)) max 0 min 1
]