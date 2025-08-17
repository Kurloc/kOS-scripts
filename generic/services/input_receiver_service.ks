

// print "hello!".
// UNTIL false { 
//     IF NOT SHIP:MESSAGES:EMPTY {
//     SET RECEIVED TO SHIP:MESSAGES:POP.
//     PRINT "Sent by " + RECEIVED:SENDER:NAME + " at " + RECEIVED:SENTAT.
//     PRINT RECEIVED:CONTENT.
//     }
// }

// local r to RotorMap()

FUNCTION InputReceiverService {
    parameter eventBus. 
    SHIP:MESSAGES:clear().
    LOCAL SELF to LEX().
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("onAwake", {
        UNLOCK STEERING.
        UNLOCK THROTTLE.
        // LOCK STEERING to "KILL".
        // LOCK THROTTLE to 0.
        // LOCK GEAR to ON.
        // LOCK BRAKE to BRAKE.
    }).
    SELF:ADD("onUpdate", {
        UNTIL SHIP:MESSAGES:EMPTY {
            SET inputEventKey TO SHIP:MESSAGES:POP:CONTENT.
            if SELF:eventBus:events:hasKey(inputEventKey) {
                SELF:eventBus:fire(inputEventKey).
            }
        }
    }).
    return SELF.
}