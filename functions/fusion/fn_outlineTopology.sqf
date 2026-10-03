/*
    Screen-space capsule-union topology.
    Adapted for ZuluFX from the permissioned whale_ecoti_llll ECOTI implementation.
*/
params ["_cd", "_cam", "_vF", "_vR", "_vU", "_pxTan", ["_smooth", false]];
// v31 : membres EFFILES (rayon different a chaque bout : cuisse large a la hanche,
//   fine au genou...), arrondis plus fins, et lissage optionnel (_smooth, grandes
//   silhouettes seulement) -> silhouette plus organique, moins "en blocs".
// ATTENTION : en SQF les noms de variables ne sont PAS sensibles a la casse
// (_R et _r sont la MEME variable). D'ou les noms _vF/_vR/_vU, _smp, etc. pour eviter tout conflit.

// --------------------------------------------------------------------------
// 1) Projection 2D des capsules (perspective, coordonnees tangente)
//    index : 0 a2 | 1 ab2 | 2 len2 | 3 rayon en A | 4 rayon en B | 5 centre
//            6 rayon englobant | 7 n2 | 8 e2 | 9 len | 10 rayon englobant^2
// --------------------------------------------------------------------------
private _c2 = _cd apply {
    if (_x isEqualTo []) then { [] } else {
        _x params ["_a3", "_ab3", "_n3", "_e3", "_rad", ["_radB", -1]];
        if (_radB < 0) then { _radB = _rad; };
        private _da = _a3 vectorDiff _cam;
        private _db = _da vectorAdd _ab3;
        private _fa = (_da vectorDotProduct _vF) max 0.05;
        private _fb = (_db vectorDotProduct _vF) max 0.05;
        private _a2 = [(_da vectorDotProduct _vR) / _fa, (_da vectorDotProduct _vU) / _fa, 0];
        private _b2 = [(_db vectorDotProduct _vR) / _fb, (_db vectorDotProduct _vU) / _fb, 0];
        private _fm = (_fa + _fb) * 0.5;
        private _ab2 = _b2 vectorDiff _a2;
        private _len = vectorMagnitude _ab2;
        private _rrA = _rad / _fm;
        private _rrB = _radB / _fm;
        private _bR  = (_len * 0.5) + (_rrA max _rrB);
        [
            _a2, _ab2, ((_len * _len) max 1e-12), _rrA, _rrB,
            (_a2 vectorAdd (_ab2 vectorMultiply 0.5)), _bR,
            [(_n3 vectorDotProduct _vR) / _fm, (_n3 vectorDotProduct _vU) / _fm, 0],
            [(_e3 vectorDotProduct _vR) / _fm, (_e3 vectorDotProduct _vU) / _fm, 0],
            _len, (_bR * _bR)
        ]
    };
};

// --------------------------------------------------------------------------
// Outils
// --------------------------------------------------------------------------
// interpolation de deux echantillons [t,c,s]
private _lerp = {
    params ["_a", "_b", "_f"];
    [
        (_a select 0) + (((_b select 0) - (_a select 0)) * _f),
        (_a select 1) + (((_b select 1) - (_a select 1)) * _f),
        (_a select 2) + (((_b select 2) - (_a select 2)) * _f)
    ]
};

// --------------------------------------------------------------------------
// 2) Bord de chaque capsule
// --------------------------------------------------------------------------
private _topo = [];
private _nC   = count _c2;

for "_i" from 0 to (_nC - 1) do {
    private _o = _c2 select _i;
    if (_o isEqualTo []) then { _topo pushBack []; continue };

    private _r  = (_cd select _i) select 4;                       // rayon en A (m)
    private _rB = (_cd select _i) param [5, _r];                  // rayon en B (m)
    if (_rB < 0) then { _rB = _r; };

    // ---- voisins : seules les capsules dont le cercle englobant touche le notre
    private _cand = [];
    {
        if ((_forEachIndex != _i) && {!(_x isEqualTo [])}
            && {((_o select 5) vectorDistance (_x select 5)) < ((_o select 6) + (_x select 6))}) then {
            _cand pushBack _forEachIndex;
        };
    } forEach _c2;

    // ---- densite adaptative : plus le membre est gros a l'ecran, plus on echantillonne
    private _rpx = ((_o select 3) max (_o select 4)) / _pxTan;
    private _m   = ((round (_rpx / 3)) max 3) min 6;                       // v34 : 3 a 6 segments (8 coutait cher de pres)
    private _k   = ((ceil (((_o select 9) / _pxTan) / 30)) max 1) min 4;   // segments par cote

    // ---- anneau ferme : cote +N, demi-cercle en B, cote -N, demi-cercle en A
    private _smp = [];
    for "_j" from 0 to (_k - 1) do { _smp pushBack [_j / _k, _r + ((_rB - _r) * (_j / _k)), 0]; };
    for "_j" from 0 to (_m - 1) do {
        private _th = _j * 180 / _m;
        _smp pushBack [1, _rB * (cos _th), _rB * (sin _th)];
    };
    for "_j" from 0 to (_k - 1) do { _smp pushBack [1 - (_j / _k), -(_r + ((_rB - _r) * (1 - (_j / _k)))), 0]; };
    for "_j" from 0 to (_m - 1) do {
        private _th = _j * 180 / _m;
        _smp pushBack [0, -_r * (cos _th), -_r * (sin _th)];
    };

    // ---- positions 2D des echantillons (v27 : calculees une seule fois, en ligne)
    private _a2o = _o select 0;
    private _abo = _o select 1;
    private _n2o = _o select 7;
    private _e2o = _o select 8;
    private _pos = _smp apply {
        _a2o vectorAdd (_abo vectorMultiply (_x select 0))
             vectorAdd (_n2o vectorMultiply (_x select 1))
             vectorAdd (_e2o vectorMultiply (_x select 2))
    };

    // ---- etat de chaque echantillon : -1 = dehors, sinon index de la capsule qui le cache
    private _st = if (_cand isEqualTo []) then {
        _smp apply { -1 }
    } else {
        _pos apply {
            private _p = _x;
            private _h = _cand findIf {
                private _q = _c2 select _x;
                ((_p vectorDistanceSqr (_q select 5)) < (_q select 10)) && {
                    private _ap = _p vectorDiff (_q select 0);
                    private _t  = (((_ap vectorDotProduct (_q select 1)) / (_q select 2)) max 0) min 1;
                    private _rt = ((_q select 3) + (((_q select 4) - (_q select 3)) * _t)) * 0.995;
                    (_ap vectorDistanceSqr ((_q select 1) vectorMultiply _t)) < (_rt * _rt)
                }
            };
            if (_h < 0) then { -1 } else { _cand select _h }
        }
    };

    // ---- parcours de l'anneau -> polylignes visibles
    private _polys = [];
    private _nSmp     = count _smp;
    private _start = _st findIf { _x < 0 };

    if (_start >= 0) then {
        private _cur = [];
        for "_q" from 0 to (_nSmp - 1) do {
            private _i0 = (_start + _q) mod _nSmp;
            private _i1 = (_i0 + 1) mod _nSmp;
            private _a0 = _st select _i0;
            private _a1 = _st select _i1;
            private _s0 = _smp select _i0;
            private _s1 = _smp select _i1;

            if (_a0 < 0) then {
                if (_a1 < 0) then {
                    // dehors -> dehors : segment complet
                    if (_cur isEqualTo []) then { _cur pushBack _s0; };
                    _cur pushBack _s1;
                } else {
                    // dehors -> dedans : on coupe au point d'entree (4 dichotomies)
                    //   v27 : la position est lineaire en [t,c,s] -> on interpole
                    //   directement les points 2D, sans appel de fonction.
                    private _p0 = _pos select _i0;
                    private _dp = (_pos select _i1) vectorDiff _p0;
                    private _qq = _c2 select _a1;
                    private _lo = 0;
                    private _hi = 1;
                    for "_b" from 1 to 4 do {
                        private _mid = (_lo + _hi) * 0.5;
                        private _ap  = (_p0 vectorAdd (_dp vectorMultiply _mid)) vectorDiff (_qq select 0);
                        private _tq  = (((_ap vectorDotProduct (_qq select 1)) / (_qq select 2)) max 0) min 1;
                        private _rq  = ((_qq select 3) + (((_qq select 4) - (_qq select 3)) * _tq)) * 0.995;
                        if ((_ap vectorDistanceSqr ((_qq select 1) vectorMultiply _tq)) < (_rq * _rq)) then { _hi = _mid; } else { _lo = _mid; };
                    };
                    if (_cur isEqualTo []) then { _cur pushBack _s0; };
                    _cur pushBack ([_s0, _s1, _hi] call _lerp);   // leger recouvrement -> pas de trou a la jonction
                    _polys pushBack _cur;
                    _cur = [];
                };
            } else {
                if (_a1 < 0) then {
                    // dedans -> dehors : on repart du point de sortie
                    private _p0 = _pos select _i0;
                    private _dp = (_pos select _i1) vectorDiff _p0;
                    private _qq = _c2 select _a0;
                    private _lo = 0;
                    private _hi = 1;
                    for "_b" from 1 to 4 do {
                        private _mid = (_lo + _hi) * 0.5;
                        private _ap  = (_p0 vectorAdd (_dp vectorMultiply _mid)) vectorDiff (_qq select 0);
                        private _tq  = (((_ap vectorDotProduct (_qq select 1)) / (_qq select 2)) max 0) min 1;
                        private _rq  = ((_qq select 3) + (((_qq select 4) - (_qq select 3)) * _tq)) * 0.995;
                        if ((_ap vectorDistanceSqr ((_qq select 1) vectorMultiply _tq)) < (_rq * _rq)) then { _lo = _mid; } else { _hi = _mid; };
                    };
                    _cur = [([_s0, _s1, _lo] call _lerp), _s1];
                };
            };
        };
        if !(_cur isEqualTo []) then { _polys pushBack _cur; };
    };

    // ---- v18 : fusion des points alignes sur les cotes droits (s = 0, meme c)
    //      -> un cote = 1 seul segment au lieu de k : moins de controles a dessiner
    _polys = _polys apply {
        private _pl  = _x;
        private _cnt = count _pl;
        if (_cnt < 3) then { _pl } else {
            private _out = [_pl # 0];
            for "_mi" from 1 to (_cnt - 2) do {
                private _pv = _pl # (_mi - 1);
                private _cu = _pl # _mi;
                private _nx = _pl # (_mi + 1);
                // cotes droits (s = 0, meme cote) : alignes meme si effiles (c lineaire en t)
                private _straight = ((_pv # 2) == 0) && {(_cu # 2) == 0} && {(_nx # 2) == 0}
                                    && {((_pv # 1) * (_cu # 1)) > 0} && {((_cu # 1) * (_nx # 1)) > 0};
                if (!_straight) then { _out pushBack _cu; };
            };
            _out pushBack (_pl # (_cnt - 1));
            _out
        }
    };

    // ---- v31 : lissage (Chaikin, 1 passe) des grandes silhouettes : coins arrondis.
    //      La position etant lineaire en [t,c,s], on lisse directement ces parametres.
    if (_smooth) then {
        _polys = _polys apply {
            private _pl = _x;
            if ((count _pl) < 3) then { _pl } else {
                private _out = [_pl # 0];
                for "_m2" from 0 to ((count _pl) - 2) do {
                    private _pa = _pl # _m2;
                    private _pb = _pl # (_m2 + 1);
                    _out pushBack ([_pa, _pb, 0.25] call _lerp);
                    _out pushBack ([_pa, _pb, 0.75] call _lerp);
                };
                _out pushBack (_pl # ((count _pl) - 1));
                _out
            }
        };
    };

    _topo pushBack _polys;
};

_topo
