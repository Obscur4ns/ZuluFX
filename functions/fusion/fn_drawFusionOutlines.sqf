/*
    Human ECOTI outline renderer.
    Uses animated bone capsules, capsule-union topology, cached body-zone occlusion
    and a transparent RscMapControl canvas for stable anti-aliased screen-space lines.

    Core silhouette technique adapted with permission from whale_ecoti_llll.
*/
if (!hasInterface) exitWith {false};

if !(missionNamespace getVariable ["ZuluFX_fusionActive",false]) exitWith {
    ["clear"] call ZuluFX_fnc_fusionCanvas;
    false
};

if ((toUpper (missionNamespace getVariable ["ZuluFX_fusionMode","PATROL"]))!="OUTLINE") exitWith {
    ["clear"] call ZuluFX_fnc_fusionCanvas;
    false
};

private _targets=missionNamespace getVariable ["ZuluFX_fusionTargets",[]];
private _camera=positionCameraToWorld [0,0,0];
private _pairs=[];

{
    if (
        _x isEqualType objNull &&
        {!isNull _x} &&
        {_x isKindOf "CAManBase"} &&
        {alive _x} &&
        {_x isNotEqualTo player}
    ) then {
        _pairs pushBack [_camera distance _x,_x];
    };
} forEach _targets;

_pairs sort true;
private _hot=_pairs apply {_x#1};

if (_hot isEqualTo []) exitWith {
    ["clear"] call ZuluFX_fnc_fusionCanvas;
    true
};

private _window=[] call ZuluFX_fnc_getFusionWindow;
if ((count _window)!=4) exitWith {
    ["clear"] call ZuluFX_fnc_fusionCanvas;
    false
};
_window params ["_bx0","_by0","_bw","_bh"];
private _bx1=_bx0+_bw;
private _by1=_by0+_bh;
private _halfW=_bw*0.5;
private _halfH=_bh*0.5;

private _modeData=[] call ZuluFX_fnc_getFusionModeData;
_modeData params ["","_range"];

private _detailR=(_range*0.75) max 80 min 250;
private _col=missionNamespace getVariable ["ZuluFX_fusionOutlineColor",[1.00,1.00,1.00,1.00]];
private _bright=1.0;
private _wCore=(missionNamespace getVariable ["ZuluFX_fusionOutlineLineWidth",1.7]) max 0.5 min 6;
private _clip=true;
private _budget=(missionNamespace getVariable ["ZuluFX_fusionOutlineTopoBudget",3]) max 1 min 8;
private _ivBase=(missionNamespace getVariable ["ZuluFX_fusionOutlineTopoInterval",0.08]) max 0.02 min 0.5;
private _opac=(missionNamespace getVariable ["ZuluFX_fusionOutlineOpacity",0.92]) max 0.05 min 1;
private _whit=0;
private _occl=true;
private _rays=(missionNamespace getVariable ["ZuluFX_fusionOutlineRayBudget",18]) max 0 min 48;
private _visIv=(missionNamespace getVariable ["ZuluFX_fusionOutlineVisibilityInterval",0.15]) max 0.05 min 1;
private _wMinF=0.62;
private _resScl=true;
private _softMin=90;
private _glowOn=missionNamespace getVariable ["ZuluFX_fusionOutlineGlow",true];
private _maxT=(missionNamespace getVariable ["ZuluFX_fusionOutlineMaxTargets",12]) max 1 min 32;
private _sensRes=(missionNamespace getVariable ["ZuluFX_fusionOutlineSensorResolution",640]) max 80 min 1024;
private _drawn=0;

private _cal=["begin"] call ZuluFX_fnc_fusionCanvas;
if (_cal isEqualTo []) exitWith {false};
_cal params ["_mcx","_mcy","_mkx","_mky","_mapC"];

private _bMul=_bright min 1;
private _bAdd=(((_bright-1) max 0)/4) min 1;
private _edgeCol=[0,1,2] apply {
    (((((_col#_x)*(1-_whit))+_whit)*_bMul) max _bAdd) min 1
};
private _lvlMul=[1,0.55,0.25];
private _colsCore=_lvlMul apply {[_edgeCol#0,_edgeCol#1,_edgeCol#2,_opac*_x]};
private _glowAlpha=(missionNamespace getVariable ["ZuluFX_fusionOutlineGlowAlpha",0.14]) max 0 min 0.5;
private _colsSoft=_lvlMul apply {[_edgeCol#0,_edgeCol#1,_edgeCol#2,_opac*_glowAlpha*_x]};

private _camPos=positionCameraToWorld [0,0,0];
private _camASLr=AGLToASL _camPos;
private _fwdN=vectorNormalized ((AGLToASL (positionCameraToWorld [0,0,10])) vectorDiff _camASLr);
private _rgtN=vectorNormalized ((AGLToASL (positionCameraToWorld [10,0,0])) vectorDiff _camASLr);
private _upN=vectorNormalized ((AGLToASL (positionCameraToWorld [0,10,0])) vectorDiff _camASLr);
private _camTer=(_camASLr#2)-(_camPos#2);
private _camASL=AGLToASL (_camPos vectorAdd (_fwdN vectorMultiply 0.6));
private _ign1=vehicle player;

private _kY=missionNamespace getVariable ["ZuluFX_fusionOutline_kY",0];
private _kX=missionNamespace getVariable ["ZuluFX_fusionOutline_kX",0];
private _p0=worldToScreen (positionCameraToWorld [0,0,100]);
private _pY=worldToScreen (positionCameraToWorld [0,1,100]);
private _pX=worldToScreen (positionCameraToWorld [1,0,100]);

if (
    (count _p0)>=2 &&
    {(count _pY)>=2} &&
    {(count _pX)>=2}
) then {
    private _newKY=(abs ((_pY#1)-(_p0#1)))/0.01;
    private _newKX=(abs ((_pX#0)-(_p0#0)))/0.01;

    if ((_newKY>0.20) && {_newKY<60}) then {
        _kY=_newKY;
        missionNamespace setVariable ["ZuluFX_fusionOutline_kY",_kY];
    };

    if ((_newKX>0.20) && {_newKX<60}) then {
        _kX=_newKX;
        missionNamespace setVariable ["ZuluFX_fusionOutline_kX",_kX];
    };
};

if (_kY<=0) then {_kY=1.2};
if (_kX<=0) then {_kX=_kY};

private _tanHalf=((_halfH/_kY) max 0.003) min 1;
private _tanHalfX=((_halfW/_kX) max 0.003) min 1;
private _tanWarm=_tanHalf*1.20;
private _tanWarmX=_tanHalfX*1.20;
private _resY=(getResolution select 1) max 1;
private _pxTan=(pixelH/_kY) max 1e-6;
private _pxTan1080=_pxTan*(_resY/1080);

private _scl=if (_resScl) then {_resY/1080} else {1};
private _wMin=(1.35*_scl) max 1.1;
private _wFull=_wCore*_scl;
private _wSoft=(_wCore+2.2)*_scl;

private _lod = [
    // capsule = [os A, os B, rayon en A, extension, rayon en B, role]
    //   membres EFFILES, barre d'epaules (plus fine que le haut du bras pour que ses
    //   bouts restent caches), et v32 : dimensions ADAPTEES A L'EQUIPEMENT de chaque
    //   soldat (voir "_gear" plus bas). Les rayons ci-dessous = soldat SANS equipement.
    //   role : 0 normal | 1 tete (casque / coiffe) | 2 torse (gilet) | 3 sac a dos
    //   Le sac est une capsule entre deux points "virtuels" places derriere le dos ;
    //   sans sac, elle est minuscule et cachee dans le torse.
    // 0 = proche : v34 meme squelette que le niveau moyen (13 membres). Les mains
    //     prolongees et les orteils coutaient cher pour un detail invisible.
    [
        ["head", "neck", "spine3", "pelvis",
         "leftarm", "leftforearm", "lefthand",
         "rightarm", "rightforearm", "righthand",
         "leftupleg", "leftleg", "leftfoot",
         "rightupleg", "rightleg", "rightfoot"],
        [[3, 2, 0.16, 0, 0.19, 2], [2, 1, 0.17, 0, 0.08, 2], [0, 1, 0.105, 0.11, 0.095, 1], [4, 7, 0.068, 0, 0.068, 0],
         [4, 5, 0.075, 0, 0.055, 0], [5, 6, 0.055, 0, 0.042, 0],
         [7, 8, 0.075, 0, 0.055, 0], [8, 9, 0.055, 0, 0.042, 0],
         [10, 11, 0.115, 0, 0.07, 0], [11, 12, 0.07, 0, 0.05, 0],
         [13, 14, 0.115, 0, 0.07, 0], [14, 15, 0.07, 0, 0.05, 0],
         [16, 17, 0.15, 0, 0.13, 3]],
        [0, 2, 5, 7, 9, 11],
        [0, 0, 1, 0, 2, 2, 3, 3, 4, 4, 5, 5, 0],
        6,
        [2, 3]
    ],
    // 1 = moyen : 16 os (+2 virtuels), 13 membres, 6 zones
    [
        ["head", "neck", "spine3", "pelvis",
         "leftarm", "leftforearm", "lefthand",
         "rightarm", "rightforearm", "righthand",
         "leftupleg", "leftleg", "leftfoot",
         "rightupleg", "rightleg", "rightfoot"],
        [[3, 2, 0.16, 0, 0.19, 2], [2, 1, 0.17, 0, 0.08, 2], [0, 1, 0.105, 0.11, 0.095, 1], [4, 7, 0.068, 0, 0.068, 0],
         [4, 5, 0.075, 0, 0.055, 0], [5, 6, 0.055, 0, 0.042, 0],
         [7, 8, 0.075, 0, 0.055, 0], [8, 9, 0.055, 0, 0.042, 0],
         [10, 11, 0.115, 0, 0.07, 0], [11, 12, 0.07, 0, 0.05, 0],
         [13, 14, 0.115, 0, 0.07, 0], [14, 15, 0.07, 0, 0.05, 0],
         [16, 17, 0.15, 0, 0.13, 3]],
        [0, 2, 5, 7, 9, 11],
        [0, 0, 1, 0, 2, 2, 3, 3, 4, 4, 5, 5, 0],
        6,
        [2, 3]
    ],
    // 2 = lointain : 7 os (+2 virtuels), 8 membres, 4 zones
    [
        ["head", "spine3", "pelvis", "lefthand", "righthand", "leftfoot", "rightfoot"],
        [[2, 1, 0.17, 0, 0.20, 2], [1, 0, 0.13, 0, 0.09, 2], [0, 1, 0.105, 0.09, 0.095, 1],
         [1, 3, 0.08, 0, 0.05, 0], [1, 4, 0.08, 0, 0.05, 0],
         [2, 5, 0.12, 0, 0.06, 0], [2, 6, 0.12, 0, 0.06, 0],
         [7, 8, 0.15, 0, 0.13, 3]],
        [0, 2, 5, 6],
        [0, 1, 1, 0, 0, 2, 3, 0],
        3,
        [1, 2]
    ],
    // 3 = tache (v30) : cible de quelques pixels sur le capteur -> forme simple
    [
        ["head", "pelvis", "leftfoot", "rightfoot"],
        [[1, 0, 0.24, 0], [1, 2, 0.20, 0], [1, 3, 0.20, 0]],
        [0],
        [0, 0, 0],
        2
    ]
];

// ==========================================================================
// Pre-passe : quelles cibles ont droit a un recalcul de topologie cette image
//   (seulement celles deja dans la fenetre a l'image precedente,
//    les plus "en retard" d'abord, limite = _budget)
// ==========================================================================
private _now    = diag_tickTime;
private _lastIn = missionNamespace getVariable ["ZuluFX_fusionOutline_inWin", []];
private _inWin  = [];
private _stale  = [];
{
    if (!isNull _x) then {
        private _cache = _x getVariable ["ZuluFX_fusionOutline_topo28", []];
        private _lv    = _x getVariable ["ZuluFX_fusionOutline_lod28", 0];
        if ((_cache isEqualTo []) || {(_cache # 1) != _lv}) then {
            _stale pushBack [1e6, _forEachIndex];
        } else {
            private _age = _now - (_cache # 0);
            if (_age >= (_cache # 3)) then { _stale pushBack [_age / (_cache # 3), _forEachIndex]; };
        };
    };
} forEach _lastIn;
_stale sort false;
private _redo = (_stale select [0, _budget]) apply { _lastIn # (_x # 1) };

private _core = [];     // [a, b, couleur, epaisseur] pour drawLine
private _soft = [];

// ==========================================================================
// Boucle principale
// ==========================================================================
{
    private _obj = _x;
    if (isNull _obj) then { continue };

    // ---- v29 : plafond de silhouettes choisi par le joueur (les plus proches d'abord :
    //      la liste des cibles est triee par distance) ----
    if ((_maxT > 0) && {_drawn >= _maxT}) then { continue };

    // ---- rejet rapide + "entierement dans la fenetre ?" (un seul point) ----
    // v30.1 : vrai centre du corps = pieds + 0,8 m. Avant, le point de reference
    //   etait pris au-dessus de l'origine du modele, qui chez les soldats n'est
    //   pas aux pieds : il tombait vers la tete. Resultat : une cible au bord
    //   BAS de la fenetre etait jugee "entierement dedans" (contour non coupe,
    //   il debordait sous la fenetre) et le comportement en haut etait decale.
    private _pASL = getPosASLVisual _obj;
    // camera exprimee dans le repere AGL du terrain de CETTE cible
    private _camU = _camPos vectorAdd [0, 0, _camTer - ((_pASL # 2) - ((ASLToAGL _pASL) # 2))];
    private _c0 = (_pASL vectorAdd [0, 0, 0.8]) vectorDiff _camASLr;
    private _f0 = _c0 vectorDotProduct _fwdN;
    if (_f0 < -2.2) then { continue };
    private _fullIn = false;
    if (_f0 > 0.5) then {
        private _u0 = abs ((_c0 vectorDotProduct _rgtN) / _f0);
        private _v0 = abs ((_c0 vectorDotProduct _upN) / _f0);
        private _mg = 2.2 / _f0;
        if ((_u0 > (_tanWarmX + _mg)) || {_v0 > (_tanWarm + _mg)}) then { continue };
        // marge 1,5 m : la silhouette entiere tient dans la fenetre -> pas de decoupe
        private _mi = 1.5 / _f0;
        _fullIn = ((_u0 + _mi) < _tanHalfX) && {(_v0 + _mi) < _tanHalf};
    };

    private _dist  = _camASLr distance _pASL;
    // v30 : estompe sur le dernier quart de la portee, rien au-dela
    private _fade  = ((_range - _dist) / (0.25 * _range)) min 1;
    if (_fade <= 0.02) then { continue };
    private _h1080 = 1.8 / ((_dist max 0.5) * _pxTan1080);   // hauteur a l'ecran, en px 1080p

    // ---- v30 : capteur thermique simule ----
    //   _mpp   : metres couverts par UN pixel du capteur a cette distance
    //   _hSens : hauteur d'un homme en pixels capteur
    private _mpp   = ((_dist max 0.5) * 2 * _tanHalf) / _sensRes;
    private _hSens = 1.8 / _mpp;
    private _infl  = (_mpp * 0.5) min 0.12;      // flou du capteur : silhouette legerement arrondie

    // ---- niveau de detail (hysteresis pour ne pas alterner au seuil) ----
    private _lvOld = _obj getVariable ["ZuluFX_fusionOutline_lod28", 0];
    private _lvScr = if (_dist > _detailR) then { 2 } else {
        switch (_lvOld min 2) do {
            case 0: { if (_h1080 < 140) then { if (_h1080 < 55) then { 2 } else { 1 } } else { 0 } };
            case 1: { if (_h1080 > 160) then { 0 } else { if (_h1080 < 55) then { 2 } else { 1 } } };
            default { if (_h1080 > 160) then { 0 } else { if (_h1080 > 65) then { 1 } else { 2 } } };
        }
    };
    // niveau impose par le capteur : >= 60 px detail complet, 25-60 moyen,
    // 10-25 simplifie, < 10 tache. Pour redevenir plus detaille : 15 % de marge.
    private _lvS = if (_hSens >= 60) then { 0 } else { if (_hSens >= 25) then { 1 } else { if (_hSens >= 10) then { 2 } else { 3 } } };
    if (_lvS < _lvOld) then {
        private _hq = _hSens / 1.15;
        _lvS = (if (_hq >= 60) then { 0 } else { if (_hq >= 25) then { 1 } else { if (_hq >= 10) then { 2 } else { 3 } } }) min _lvOld;
    };
    private _lv = _lvScr max _lvS;
    if (_lv != _lvOld) then { _obj setVariable ["ZuluFX_fusionOutline_lod28", _lv]; };
    (_lod # _lv) params ["_boneList", "_capList", "_probes", "_pmap", "_minPts", ["_spIdx", []]];

    // ---- v28.3 : geometrie en cache pour les silhouettes moyennes / petites ----
    //   Grande silhouette : tout est recalcule a chaque image.
    //   Moyenne : ~30x/s, petite : ~20x/s. Entre deux, on reutilise la forme
    //   (points stockes RELATIVEMENT a la cible) recalee sur sa position
    //   actuelle : le contour suit toujours le deplacement de la cible et le
    //   mouvement de la camera a chaque image, seule l'animation des membres
    //   est echantillonnee un peu moins souvent (invisible a cette taille).
    // v34 : aussi pour les silhouettes PROCHES (~40x/s). Avant, tout etait recalcule
    //       a chaque image pour elles : lecture des os, membres, reconstruction.
    private _geoIv = [0.025, 0.033, 0.05, 0.08] select _lv;
    private _gc    = _obj getVariable ["ZuluFX_fusionOutline_geo28", []];
    private _lines = [];     // [[points monde], niveau d'opacite]

    if ((_geoIv > 0) && {!(_gc isEqualTo [])} && {(_gc # 1) == _lv} && {(_now - (_gc # 0)) < _geoIv} && {!(_obj in _redo)}) then {
        _inWin pushBack _obj;
        private _anc = _obj modelToWorldVisual [0, 0, 0];
        _lines = (_gc # 2) apply { [((_x # 0) apply { _anc vectorAdd _x }), _x # 1] };
    } else {
        // ---- positions des os dans le modele ----
        private _sps = _boneList apply {
            private _sp = _obj selectionPosition _x;
            if (_sp isEqualTo [0, 0, 0]) then { [] } else { _sp }
        };

        // ---- v32 : equipement du soldat (relu toutes les 3 s, change rarement) ----
        //   tete : 0 rien | 1 coiffe souple (bonnet, turban...) | 2 casque (protection > 0)
        //   gilet : 0 rien | 1 chest rig / gilet leger | 2 gilet pare-balles (protection >= 10)
        //   sac : oui / non
        private _gr = _obj getVariable ["ZuluFX_fusionOutline_gear32", []];
        if ((_gr isEqualTo []) || {(_now - (_gr # 0)) > 3}) then {
            private _gMap = missionNamespace getVariable ["ZuluFX_fusionOutline_gearMap", createHashMap];
            private _armor = {
                params ["_cls", "_hp"];
                private _key = toLower (_cls + "|" + _hp);
                private _v = _gMap getOrDefault [_key, -1];
                if (_v < 0) then {
                    _v = getNumber (configFile >> "CfgWeapons" >> _cls >> "ItemInfo" >> "HitpointsProtectionInfo" >> _hp >> "armor");
                    _gMap set [_key, _v];
                };
                _v
            };
            private _hg = headgear _obj;
            private _vs = vest _obj;
            private _gH = if (_hg == "") then { 0 } else { if (([_hg, "Head"] call _armor) > 0) then { 2 } else { 1 } };
            private _gV = if (_vs == "") then { 0 } else {
                if (((([_vs, "Chest"] call _armor) max ([_vs, "Body"] call _armor))) >= 10) then { 2 } else { 1 }
            };
            missionNamespace setVariable ["ZuluFX_fusionOutline_gearMap", _gMap];
            _gr = [_now, _gH, _gV, (backpack _obj) != ""];
            _obj setVariable ["ZuluFX_fusionOutline_gear32", _gr];
        };
        _gr params ["", "_gH", "_gV", "_gP"];

        // ---- points virtuels du sac (repere du modele : +y = devant) ----
        if !(_spIdx isEqualTo []) then {
            private _bpA = _sps # (_spIdx # 0);
            private _bpB = _sps # (_spIdx # 1);
            if ((_bpA isEqualTo []) || {_bpB isEqualTo []}) then {
                _sps pushBack [];
                _sps pushBack [];
            } else {
                if (_gP) then {
                    _sps pushBack (_bpA vectorAdd [0, -0.22, 0]);       // haut du sac, derriere les omoplates
                    _sps pushBack (_bpB vectorAdd [0, -0.20, 0.15]);    // bas du sac, derriere les reins
                } else {
                    _sps pushBack _bpA;
                    _sps pushBack _bpB;
                };
            };
        };

        // ---- os en position VISUELLE ----
        private _nOk = 0;
        private _pts = _sps apply {
            if (_x isEqualTo []) then { [] } else { _nOk = _nOk + 1; _obj modelToWorldVisual _x };
        };
        if (_nOk < _minPts) then { continue };

        // ---- dans la fenetre ECOTI ? ----
        private _inside = _fullIn;
        if (!_inside) then {
            {
                if !(_x isEqualTo []) then {
                    private _d = _x vectorDiff _camU;
                    private _f = _d vectorDotProduct _fwdN;
                    if (_f > 0.05) then {
                        // os dans la zone elargie, + epaisseur du corps (~0,4 m)
                        private _mb = 0.4 / _f;
                        if ((abs ((_d vectorDotProduct _rgtN) / _f) <= (_tanWarmX + _mb))
                            && {abs ((_d vectorDotProduct _upN) / _f) <= (_tanWarm + _mb)}) then { _inside = true; };
                    };
                };
                if (_inside) exitWith {};
            } forEach _pts;
        };
        if (!_inside) then { continue };
        _inWin pushBack _obj;

        // ---- topologie : cache ou recalcul (budget) ----
        private _cache   = _obj getVariable ["ZuluFX_fusionOutline_topo28", []];
        private _needAll = _obj in _redo;
        private _topo    = [];
        if (!_needAll) then {
            if ((_cache isEqualTo []) || {(_cache # 1) != _lv}) then { continue };   // pas encore pret
            _topo = _cache # 2;
            if ((count _topo) != (count _capList)) then { continue };
        };

        // ---- capsules : seulement celles qui ont un bord visible (toutes si recalcul)
        //      v28.3 : compteur explicite (_forEachIndex n'existe pas dans "apply")
        private _ci = -1;
        private _cd = _capList apply {
            _ci = _ci + 1;
            if (!_needAll && {(_topo # _ci) isEqualTo []}) then { [] } else {
                _x params ["_ia", "_ib", "_r", "_ext", ["_rB", -1], ["_role", 0]];
                if (_rB < 0) then { _rB = _r; };
                // v32 : ajustement selon l'equipement
                switch (_role) do {
                    case 1: {
                        private _dh = [0, 0.005, 0.012] select _gH;
                        _ext = _ext + ([0, 0.02, 0.045] select _gH);
                        _r = _r + _dh;
                        _rB = _rB + _dh;
                    };
                    case 2: {
                        private _dv = [0, 0.012, 0.03] select _gV;
                        _r = _r + _dv;
                        _rB = _rB + _dv;
                    };
                    case 3: {
                        if (!_gP) then { _r = 0.02; _rB = 0.02; };
                    };
                };
                private _pa = _pts # _ia;
                private _pb = _pts # _ib;
                if ((_pa isEqualTo []) || {_pb isEqualTo []}) then { [] } else {
                    private _b3 = _pb;
                    if (_ext > 0) then {
                        _b3 = _pa vectorAdd ((vectorNormalized (_pa vectorDiff _pb)) vectorMultiply _ext);
                    };
                    private _ab3  = _b3 vectorDiff _pa;
                    private _view = vectorNormalized ((_pa vectorAdd (_ab3 vectorMultiply 0.5)) vectorDiff _camU);
                    private _dir  = if ((vectorMagnitude _ab3) < 0.005) then { _upN } else { vectorNormalized _ab3 };
                    private _n3   = _dir vectorCrossProduct _view;
                    if ((vectorMagnitude _n3) < 1e-3) then { _n3 = _rgtN; };
                    _n3 = vectorNormalized _n3;
                    [_pa, _ab3, _n3, vectorNormalized (_view vectorCrossProduct _n3), _r + _infl, _rB + _infl]
                }
            }
        };

        if (_needAll) then {
            // v31 : lissage pour les grandes silhouettes seulement (la ou il se voit)
            _topo = [_cd, _camU, _fwdN, _rgtN, _upN, _pxTan1080, false] call ZuluFX_fnc_outlineTopology;   // v34 : lissage retire (cout x2)
            // v34 : frequence de recalcul normale aussi pour les grandes silhouettes
            //       (v31 la doublait : c'etait le poste le plus couteux de pres)
            _cache = [_now, _lv, _topo, ((_ivBase * (1 + (_dist / 25))) * ([1, 1.5, 2, 2.5] select _lv)) min 0.6];
            _obj setVariable ["ZuluFX_fusionOutline_topo28", _cache];
        };

        // ---- occlusion par zone du corps (murs, batiments, vegetation) ----
        private _vis = [];
        if (_occl) then {
            private _vc = _obj getVariable ["ZuluFX_fusionOutline_vis28", []];
            private _vStale = (_vc isEqualTo []) || {(_vc # 1) != _lv} || {(_now - (_vc # 0)) >= _visIv};
            if (_vStale && {_rays > 0}) then {
                private _vNew = _probes apply {
                    private _pa = _pts # ((_capList # _x) # 0);
                    private _pb = _pts # ((_capList # _x) # 1);
                    if ((_pa isEqualTo []) || {_pb isEqualTo []}) then { 1 } else {
                        private _pASL = AGLToASL ((_pa vectorAdd _pb) vectorMultiply 0.5);
                        private _v = [_ign1, "VIEW", _obj] checkVisibility [_camASL, _pASL];
                        // v28.4 : un AUTRE SOLDAT devant ne doit pas faire disparaitre le
                        //   contour (colonne, groupe serre). Si le rayon est bloque, on
                        //   regarde ce qui le bloque : uniquement des soldats -> visible.
                        //   (murs, terrain, vehicules, vegetation continuent de masquer)
                        if (_v < 0.70) then {
                            private _hits = lineIntersectsSurfaces [_camASL, _pASL, _ign1, _obj, true, 4, "VIEW", "FIRE"];
                            if (!(_hits isEqualTo []) && {(_hits findIf {
                                    private _ho = _x # 3;
                                    if (isNull _ho) then { _ho = _x # 2; };
                                    (isNull _ho) || {!(_ho isKindOf "CAManBase")}
                                }) < 0}) then { _v = 1; };
                        };
                        _v
                    }
                };
                _rays = _rays - (count _probes);
                _vc = [_now, _lv, _vNew];
                _obj setVariable ["ZuluFX_fusionOutline_vis28", _vc];
            };
            if (!(_vc isEqualTo []) && {(_vc # 1) == _lv}) then { _vis = _vc # 2; };
            if (_vis isEqualTo []) then { continue };    // jamais calcule : rien (pas de flash a travers un mur)
        };

        // ---- polylignes en coordonnees monde ----
        {
            private _polys = _x;
            private _c = _cd # _forEachIndex;
            if (!(_polys isEqualTo []) && {!(_c isEqualTo [])}) then {
                private _lvl = 0;
                if !(_vis isEqualTo []) then {
                    private _v = _vis # (_pmap # _forEachIndex);
                    _lvl = if (_v >= 0.70) then { 0 } else { if (_v >= 0.35) then { 1 } else { if (_v >= 0.10) then { 2 } else { -1 } } };
                };
                if (_lvl >= 0) then {
                    _c params ["_a3", "_ab3", "_n3", "_e3"];
                    {
                        _lines pushBack [(_x apply {
                            _a3 vectorAdd (_ab3 vectorMultiply (_x # 0))
                                vectorAdd (_n3 vectorMultiply (_x # 1))
                                vectorAdd (_e3 vectorMultiply (_x # 2))
                        }), _lvl];
                    } forEach _polys;
                };
            };
        } forEach _topo;

        // ---- mise en cache (points relatifs a la cible) ----
        if (_geoIv > 0) then {
            private _anc = _obj modelToWorldVisual [0, 0, 0];
            _obj setVariable ["ZuluFX_fusionOutline_geo28", [_now, _lv, _lines apply { [((_x # 0) apply { _x vectorDiff _anc }), _x # 1] }]];
        };
    };

    // ---- epaisseurs pour cette cible ----
    private _wf = ((sqrt (_h1080 / 120)) max _wMinF) min 1;
    private _wc = (_wFull * _wf) max _wMin;
    private _ws = (_wSoft * _wf) max (_wc + _wMin);
    private _doSoft = _glowOn && {_h1080 > _softMin};   // halo : grandes silhouettes, si active

    // ---- couleurs (estompees en limite de portee) ----
    private _colsC = _colsCore;
    private _colsS = _colsSoft;
    if (_fade < 1) then {
        _colsC = _colsCore apply { [_x # 0, _x # 1, _x # 2, (_x # 3) * _fade] };
        _colsS = _colsSoft apply { [_x # 0, _x # 1, _x # 2, (_x # 3) * _fade] };
    };

    // ---- polylignes -> segments de dessin (une seule passe par point) ----
    private _nBefore = count _core;
    {
        _x params ["_wpts", "_lvl"];
        private _colC = _colsC # _lvl;
        private _colS = _colsS # _lvl;
        if (_fullIn || {!_clip}) then {
            // cas courant : aucune decoupe
            private _pv = [];
            {
                private _s  = worldToScreen _x;
                private _mp = if ((count _s) < 2) then { [] } else { _mapC ctrlMapScreenToWorld _s };
                if (!(_pv isEqualTo []) && {!(_mp isEqualTo [])}) then {
                    _core pushBack [_pv, _mp, _colC, _wc];
                    if (_doSoft) then { _soft pushBack [_pv, _mp, _colS, _ws]; };
                };
                _pv = _mp;
            } forEach _wpts;
        } else {
            // cible au bord de la fenetre : decoupe Liang-Barsky
            private _scr = _wpts apply { worldToScreen _x };
            for "_q" from 0 to ((count _scr) - 2) do {
                private _sa = _scr # _q;
                private _sb = _scr # (_q + 1);
                if (((count _sa) >= 2) && {(count _sb) >= 2}) then {
                    private _x0 = _sa # 0;  private _y0 = _sa # 1;
                    private _ddx = (_sb # 0) - _x0;
                    private _ddy = (_sb # 1) - _y0;
                    private _t0 = 0;
                    private _t1 = 1;
                    {
                        _x params ["_lbP", "_lbQ"];
                        if (_lbP == 0) then {
                            if (_lbQ < 0) then { _t0 = 2; };
                        } else {
                            private _lbR = _lbQ / _lbP;
                            if (_lbP < 0) then {
                                if (_lbR > _t1) then { _t0 = 2; } else { if (_lbR > _t0) then { _t0 = _lbR; }; };
                            } else {
                                if (_lbR < _t0) then { _t0 = 2; } else { if (_lbR < _t1) then { _t1 = _lbR; }; };
                            };
                        };
                    } forEach [[-_ddx, _x0 - _bx0], [_ddx, _bx1 - _x0], [-_ddy, _y0 - _by0], [_ddy, _by1 - _y0]];
                    if (_t0 < _t1) then {
                        private _ma = _mapC ctrlMapScreenToWorld [_x0 + (_ddx * _t0), _y0 + (_ddy * _t0)];
                        private _mb = _mapC ctrlMapScreenToWorld [_x0 + (_ddx * _t1), _y0 + (_ddy * _t1)];
                        _core pushBack [_ma, _mb, _colC, _wc];
                        if (_doSoft) then { _soft pushBack [_ma, _mb, _colS, _ws]; };
                    };
                };
            };
        };
    } forEach _lines;

    // ne compte que les silhouettes reellement tracees dans la fenetre
    // (une cible dans la zone de pre-chauffe, hors fenetre, ne consomme pas le plafond)
    if ((count _core) > _nBefore) then { _drawn = _drawn + 1; };
} forEach _hot;

// fondu d'abord (dessous), trait principal ensuite (dessus)
["set",_soft+_core] call ZuluFX_fnc_fusionCanvas;
missionNamespace setVariable ["ZuluFX_fusionOutline_profStat",[count _inWin,(count _core)+(count _soft),count _hot,_kY,_drawn]];
missionNamespace setVariable ["ZuluFX_fusionOutline_inWin",_inWin];
true