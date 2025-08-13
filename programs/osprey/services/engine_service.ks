RUN "0:/programs/osprey/constants.ks".

// An Object that implements OnUpdate
FUNCTION EngineSerivce {
    parameter engineMap, actionGroupCache, eventBus.

    LOCAL SELF to LEX().
    SELF:ADD("engineMap", engineMap).
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("actionGroupCache", actionGroupCache).
    SELF:ADD("setThrust", {}).
    SELF:ADD("activateEngines", {
        for i in range(0, SELF:engineMap:engines:length) { 
            SELF:engineMap:engines[i]:activate().
            SELF:eventBus:fire1(EVENT_ENGINE_TOGGLE + i, true).
        }
    }).
    SELF:ADD("shutdownEngines", {
        for i in range(SELF:engineMap:engines:length) { 
            SELF:engineMap:engines[i]:shutdown().
            SELF:eventBus:fire1(EVENT_ENGINE_TOGGLE + i, false).
        }
    }).
    SELF:ADD("toggleEngines", {
        LOCAL ignitionState to SELF:engineMap:engines[0]:ignition.
        for i in range(SELF:engineMap:engines:length) { 
            if ignitionState { 
                SELF:engineMap:engines[i]:shutdown().
                SET SHIP:CONTROL:PILOTMAINTHROTTLE to 0.
            } else { 
                SELF:engineMap:engines[i]:activate().
                SET SHIP:CONTROL:PILOTMAINTHROTTLE to 1.
            }
            SELF:eventBus:fire1(EVENT_ENGINE_TOGGLE + i, not ignitionState).
        }
    }).
    SELF:ADD("onUpdate", {
        parameter physicsTick.
        if MOD(physicsTick, 30) = 0 { 
            for i in range(SELF:engineMap:engines:length) { 
                LOCAL eng to SELF:engineMap:engines[i].
                SELF:eventBus:fire1(EVENT_ENGINE_THRUST_CHANGE + i, eng:thrust / eng:POSSIBLETHRUST * 100).
            }
        }
    }).

    return SELF.
}
