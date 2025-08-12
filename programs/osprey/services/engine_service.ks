// An Object that implements OnUpdate
FUNCTION EngineSerivce {
    parameter engineMap, actionGroupCache, eventBus.

    LOCAL SELF to LEX().
    SELF:ADD("engineMap", engineMap).
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("actionGroupCache", actionGroupCache).

    LOCAL _on_update is {
        for i in range(SELF:engineMap:engines:length) { 
            LOCAL eng to SELF:engineMap:engines[i].
            SELF:eventBus:fire1(EVENT_ENGINE_THRUST_CHANGE + i, eng:thrust / eng:POSSIBLETHRUST * 100).
            SELF:eventBus:fire1(EVENT_ENGINE_TOGGLE + i, eng:ignition).
        }
    }.

    SELF:ADD("on_update", _on_update).

    return SELF.
}
