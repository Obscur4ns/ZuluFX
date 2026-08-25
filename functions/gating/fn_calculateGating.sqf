private _probe = call ZuluFX_fnc_sampleProbe;
private _dynamic = _probe select 1;
(_dynamic / (_dynamic + 1.5)) max 0 min 1