RUN "0:/programs/osprey/constants.ks".

// An Object that implements OnUpdate
FUNCTION SynchronizedControlSurfaceSerivce {
    parameter ctrlSurfaceMap, actionGroupCache, eventBus.

    LOCAL SELF to LEX().
    SELF:ADD("ctrlSurfaceMap", ctrlSurfaceMap).
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("actionGroupCache", actionGroupCache).

    LOCAL _on_update is {
        if AG2 <> SELF:actionGroupCache:ag2 {
            for ctrlSurface in SELF:ctrlSurfaceMap:ctrlSurfaces {
                ctrlSurface:lock().
            }
            SELF:eventBus:fire1(SELF:eventBus, EVENT_CTRL_SURFACE_LOCK_STATUS_CHANGE, "pitch, yaw, roll").
            SET SELF:actionGroupCache:ag2 to AG2.
        }

        if AG3 <> SELF:actionGroupCache:ag3 {
            for ctrlSurface in SELF:ctrlSurfaceMap:ctrlSurfaces {
                ctrlSurface:unlock().
            }
            SELF:eventBus:fire1(SELF:eventBus, EVENT_CTRL_SURFACE_LOCK_STATUS_CHANGE, "false").
            SET SELF:actionGroupCache:ag3 to AG3.
        }
    }.

    SELF:ADD("on_update", _on_update).

    return SELF.
}
