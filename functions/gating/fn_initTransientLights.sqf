if (!hasInterface) exitWith {};

ZuluFX_transientLights = [];
ZuluFX_explosionPowerCache = createHashMap;
ZuluFX_ehFiredNear = -1;
ZuluFX_ehFired = -1;

["unit",{
    params ["_new","_old"];

    if (!isNull _old) then {
        if (ZuluFX_ehFiredNear >= 0) then {_old removeEventHandler ["FiredNear",ZuluFX_ehFiredNear]};
        if (ZuluFX_ehFired >= 0) then {_old removeEventHandler ["Fired",ZuluFX_ehFired]};
    };

    ZuluFX_ehFiredNear = -1;
    ZuluFX_ehFired = -1;
    if (isNull _new) exitWith {};

    ZuluFX_ehFiredNear = _new addEventHandler ["FiredNear",{
        params ["","_firer"];
        if (!(missionNamespace getVariable ["ZuluFX_nvgActive",false]) || {isNull _firer}) exitWith {};
        private _w = currentWeapon _firer;
        private _dir = if (_w isEqualTo "") then {eyeDirection _firer} else {_firer weaponDirection _w};
        private _pos = (eyePos _firer) vectorAdd ((vectorNormalized _dir) vectorMultiply 0.6);
        [_pos,40,0.37,1] call ZuluFX_fnc_addTransientLight;
    }];

    ZuluFX_ehFired = _new addEventHandler ["Fired",{
        params ["_unit"];
        if (!(missionNamespace getVariable ["ZuluFX_nvgActive",false])) exitWith {};
        private _w = currentWeapon _unit;
        private _dir = if (_w isEqualTo "") then {eyeDirection _unit} else {_unit weaponDirection _w};
        private _pos = (eyePos _unit) vectorAdd ((vectorNormalized _dir) vectorMultiply 0.6);
        [_pos,55,0.37,1] call ZuluFX_fnc_addTransientLight;
    }];
},true] call CBA_fnc_addPlayerEventHandler;

addMissionEventHandler ["ProjectileCreated",{
    params ["_projectile"];
    if (!(missionNamespace getVariable ["ZuluFX_nvgActive",false])) exitWith {};
    private _type = typeOf _projectile;
    private _power = [_type] call ZuluFX_fnc_getExplosionPower;
    if (_power <= 0) exitWith {};
    _projectile setVariable ["ZuluFX_explosionPower",_power];
    _projectile addEventHandler ["Explode",{
        params ["_projectile","_pos"];
        if (!(missionNamespace getVariable ["ZuluFX_nvgActive",false])) exitWith {};
        private _power = _projectile getVariable ["ZuluFX_explosionPower",0];
        if (_power > 0) then {[_pos,_power,0.4,2] call ZuluFX_fnc_addTransientLight};
    }];
}];