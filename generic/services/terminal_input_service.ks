// Implements OnUpdate
// We are going to cache the eventBus keys on init so register your keys you want to listen to
// before calling this.
// 
// For now Im only going to worry about events that need 0 params.
FUNCTION TerminalInputService {
    parameter eventBus.

    LOCAL SELF to LEX().
    LOCAL lastChar to "".
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("eventKeys", 0).
    SELF:ADD("onUpdate", {
        if TERMINAL:input:haschar {
            if SELF:eventKeys = 0 { 
                SET SELF:eventKeys to SELF:eventBus:events:keys().
            }

            LOCAL keyPressed to TERMINAL:input:getchar().
            print keyPressed:padright(12) at (0, 45).
            if SELF:eventKeys:contains(keyPressed) {
                SELF:eventBus:fire(keyPressed).
            }
            // @TODO add keyRelease events

            SET lastChar to keyPressed.
        }
    }).

    return self.
}