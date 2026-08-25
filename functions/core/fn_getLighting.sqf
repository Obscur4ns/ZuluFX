if (!hasInterface || {isNull player}) exitWith {[0,0]};
private _lighting = getLightingAt player;
[_lighting select 1,_lighting select 3]