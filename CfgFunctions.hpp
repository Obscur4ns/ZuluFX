class CfgFunctions
{
    class ZuluFX
    {
        class Core
        {
            file="\ZuluFX\functions\Core";
            class preInit {preInit=1;};
            class postInit {postInit=1;};
            class isNVGActive {};
            class handleVisionMode {};
            class createEffects {};
            class setGrain {};
            class getLighting {};
            class getSkyExposure {};
            class updateEnvironment {};
            class startEnvironmentLoop {};
            class calculateGrain {};
            class updateGrain {};
            class startGrainLoop {postInit=1;};
            class calculateGain {};
            class updateGain {};
            class startGainLoop {postInit=1;};
            class setGain {};
        };
        class Hardware
        {
            file="\ZuluFX\functions\hardware";
            class getNVGProfile {};
            class updateNVGProfile {};
            class initHardware {postInit=1;};
        };
        class Gating
        {
            file="\ZuluFX\functions\Gating";
            class createProbe {};
            class sampleProbe {};
            class calculateGating {};
            class updateGating {};
            class startGatingLoop {postInit=1;};
            class applyGating {};
            class sampleBino {};
            class calculateBinoGating {};
            class updateBinoGating {};
            class createBinoRenderer {};
            class applyBinoRenderer {};
            class calculateBinoExposure {};
            class addTransientLight {};
            class getExplosionPower {};
            class sampleTransientLights {};
            class initTransientLights {postInit=1;};
            class initPersistentLights {postInit=1;};
            class scanPersistentLights {};
            class samplePersistentLights {};
            class getTubeMode {};
            class sampleQuad {};
            class sampleQuadTransientLights {};
            class sampleQuadPersistentLights {};
            class calculateQuadExposure {};
            class updateQuadGating {};
            class createQuadRenderer {};
            class applyQuadRenderer {};
        };
        class Colour
        {
            file="\ZuluFX\functions\colour";
            class initColourSettings {preInit=1;};
            class setPhosphor {};
            class setOutputFilter {};
        };
        class Scintillation
        {
            file="\ZuluFX\functions\scintillation";
            class initScintillation {postInit=1;};
            class createScintillation {};
            class updateScintillation {};
            class cleanupScintillation {};
            class getScintillationStyle {};
            class randomScintillationPoint {};
        };
        class Fusion
        {
            file="\ZuluFX\functions\fusion";
            class canUseFusion {};
            class getFusionSelections {};
            class getFusionModeData {};
            class restoreFusionTarget {};
            class applyFusionTarget {};
            class scanFusionCandidates {};
            class updateFusionTargets {};
            class createFusion {};
            class cleanupFusion {};
            class setFusion {};
            class setFusionMode {};
            class cycleFusionMode {};
            class handleFusionVisionInput {};
            class handleFusionVisionMode {};
            class initFusionControls {postInit=1;};
        };
        class HUD
        {
            file="\ZuluFX\functions\hud";
            class canUseCompass {};
            class createCompass {};
            class updateCompass {};
            class cleanupCompass {};
            class setCompass {};
            class canUseHUD {};
            class createHUD {};
            class updateHUD {};
            class cleanupHUD {};
            class getHUDData {};
            class createBNVDF {};
            class updateBNVDF {};
            class createFPANO {};
            class updateFPANO {};
            class updateBatteryIndicator {};
            class initHUD {postInit=1;};
        };
        class Battery
        {
            file="\ZuluFX\functions\battery";
            class initBatterySettings {preInit=1;};
            class getBatteryStateKey {};
            class getBatteryState {};
            class getBatteryLevel {};
            class getBatteryRuntime {};
            class setBatteryLevel {};
            class updateBattery {};
            class loadBattery {};
            class replaceBattery {};
            class initBatteryInteractions {};
            class initBattery {postInit=1;};
        };
        class DOF
        {
            file="\ZuluFX\functions\DOF";
            class createDOF {};
            class updateDOF {};
            class startDOFLoop {postInit=1;};
        };
    };
};
