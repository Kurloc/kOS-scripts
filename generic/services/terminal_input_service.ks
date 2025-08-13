// Implements OnUpdate
// We are going to cache the eventBus keys on init so register your keys you want to listen to
// before calling this.
// 
// For now Im only going to worry about events that need 0 params.
FUNCTION TerminalInputService {
    parameter eventBus.

    LOCAL SELF to LEX().

    SELF:ADD("eventBus", eventBus).
    SELF:ADD("eventKeys", 0).
    SELF:ADD("keyPressed", -1).
    SELF:ADD("lastChar", -1).
    SELF:ADD("deadFrames", 0).
    SELF:ADD("onUpdate", {
        if TERMINAL:input:haschar {
            SET SELF:deadFrames to 0.
            if SELF:eventKeys = 0 { 
                SET SELF:eventKeys to SELF:eventBus:events:keys().
            }

            SET SELF:keyPressed to TERMINAL:input:getchar().
            if SELF:lastChar <> -1 and SELF:lastChar <> SELF:keyPressed { 
                // print "Released A: {0}, newChar: {1} AT {2}":format(lastChar, SELF:keyPressed, physicsTick):padright(18) at (0, 47).
                LOCAL releasedEvent to SELF:keyPressed + "Released".
                if SELF:eventKeys:contains(releasedEvent) {
                    SELF:eventBus:fire(releasedEvent).
                }
            }

            // print "Pressed {0} at {1}":format(SELF:keyPressed, physicsTick):padright(15) at (0, 46).
            if SELF:keyPressed = SELF:lastChar {
                return.
            }

            if SELF:eventKeys:contains(SELF:keyPressed) {
                SELF:eventBus:fire(SELF:keyPressed).
            }
            SET SELF:lastChar to SELF:keyPressed.
            return.
        }


        SET SELF:deadFrames to SELF:deadFrames + 1.
        if SELF:deadFrames > 5 {
            SET SELF:lastChar to -1.
            SET SELF:deadFrames to 0.
        }
        if SELF:lastChar <> -1 { 
            // print "Released B: {0} on {1} :: {2}":format(lastChar, physicsTick, deadFrames):padright(15) at (0, 48).
            LOCAL releasedEvent to SELF:keyPressed + "Released".
            if SELF:eventKeys:contains(releasedEvent) {
                SELF:eventBus:fire(releasedEvent).
            }
        }
    
    }).

    return self.
}