private _probe=call ZuluFX_fnc_sampleQuad;
private _event=call ZuluFX_fnc_sampleQuadTransientLights;
private _persistent=call ZuluFX_fnc_sampleQuadPersistentLights;

if ((count _probe)!=4 || {(count _event)!=4} || {(count _persistent)!=4}) exitWith {
    ZuluFX_quadExposureFault=[_probe,_event,_persistent];
    [0,0,0,0]
};

ZuluFX_quadDynamic=_probe;
ZuluFX_quadTransient=_event;
ZuluFX_quadPersistent=_persistent;
ZuluFX_quadExposureFault=[];

private _raw=[];

for "_i" from 0 to 3 do {
    private _input=(_probe select _i) max (_event select _i);
    _input=_input max (_persistent select _i);

    private _value=1-exp(-(_input/22));
    _value=_value max 0;
    _value=_value min 1;

    _raw pushBack _value;
};

ZuluFX_quadRawExposure=_raw;
_raw