// Implements OnUpdate
// We are going to cache the eventBus keys on init so register your keys you want to listen to
// before calling this.
// 
// For now Im only going to worry about events that need 0 params.
FUNCTION TerminalInputService {
    parameter eventBus.

    LOCAL SELF to LEX().
    LOCAL misses to 0.

    SELF:ADD("eventBus", eventBus).
    SELF:ADD("eventKeys", 0).
    SELF:ADD("keyPressed", -1).
    SELF:ADD("lastChar", -1).
    SELF:ADD("onUpdate", {
        parameter physicsTick.

        if TERMINAL:input:haschar {
            if SELF:eventKeys = 0 { 
                SET SELF:eventKeys to SELF:eventBus:events:keys().
            }
            SET SELF:keyPressed to TERMINAL:input:getchar().
            TERMINAL:input:clear().

            print "Pressed: {0} AT {1}":format(SELF:keyPressed, physicsTick):padright(18) at (0, 44).
            if SELF:lastChar <> -1 and SELF:lastChar <> SELF:keyPressed { 
                LOCAL releasedEvent to SELF:keyPressed + "Released".
                print "Released A: {0}, newChar: {1} AT {2}":format(SELF:lastChar, SELF:keyPressed, physicsTick):padright(18) at (0, 47).
                if SELF:eventKeys:contains(releasedEvent) {
                    SELF:eventBus:fire(releasedEvent).
                }
            }

            // if SELF:keyPressed = SELF:lastChar {
            //     return.
            // }

            if SELF:eventKeys:contains(SELF:keyPressed) {
                SELF:eventBus:fire(SELF:keyPressed).
                SET misses to 0.
            }
            SET SELF:lastChar to SELF:keyPressed.
            return.
        }
        if misses = -1 {
            return.
        }
        if SELF:lastChar = -1 {
            return.
        }
        if misses < 18 {
            SET misses to misses + 1.
            return.
        }
         
        LOCAL releasedEvent to SELF:keyPressed + "Released".
        print "Released B: {0} on {1} :: {2}":format(SELF:lastChar, physicsTick, TERMINAL:input:haschar):padright(15) at (0, 48).
        if SELF:eventKeys:contains(releasedEvent) {
            SELF:eventBus:fire(releasedEvent).
        }
        SET SELF:lastChar to -1.
        SET misses to -1.
    }).

    return self.
}


RUN "0:/parts/rotor/__init__.ks".

local rm to ShipRotorMap().

print rm:rotors[0]:module:allactionnames().
print rm:rotors[0]:module:allactions().
print rm:rotors[0]:module:allevents().

// rm:rotors[0]:module:doEvent("move -").
rm:rotors[0]:module:doAction("move -", true).

// TERMINAL:input().

SET CONFIG:IPU to 2000.
LOCAL i to 0.
LOCAL lastChar to -1.
local keyPressed to -1.
local releaseFrame to 101.
local deadFrameBuffer to 5.
local inputBuffer to LIST().
local inputBufferCursor to 0.
local releaseCount to 0.
local pressMapToReleaseName to LEX(
    terminal:input:PAGEUPCURSOR, "PageUp", 
    terminal:input:PAGEDOWNCURSOR, "PageDown"
).
local pressMapToReleaseNameKeys to pressMapToReleaseName:keys.
for z in range(0, 30) {
    inputBuffer:add("").
}

UNTIL FALSE {
    SET i to i + 1.
    if TERMINAL:input:hasChar {
        // TERMINAL:input:getChar().
        SET keyPressed to TERMINAL:input:getChar().
        if pressMapToReleaseName:hasKey(keyPressed) { 
            SET keyPressed to pressMapToReleaseName[keyPressed].
        }

        print "[{0}]::{1} Pressed {2}":format(i:tostring():padleft(6), Time:seconds:tostring():substring(0, 11), keyPressed).
        SET releaseFrame to CHOOSE i + deadFrameBuffer if i < 95 else i + deadFrameBuffer - 100.
        SET lastChar to keyPressed.
        SET inputBuffer[inputBufferCursor] to keyPressed.
        SET releaseCount to 0.
        SHIP:CONNECTION:SENDMESSAGE(lastChar).
    } else { 
        SET inputBuffer[inputBufferCursor] to  "".
    }
    if inputBufferCursor = 29 { 
        SET inputBufferCursor to 0.
    } else { 
        SET inputBufferCursor to inputBufferCursor + 1.
    }

    if i = releaseFrame {
        local score to 0.
        for ch in inputBuffer { 
            SET score to (CHOOSE 
                score + 1 
                if ch = lastChar else
                score
            ).
        }
        SET scoreH to score / inputBuffer:length.
        if scoreH > .4 {
            SET i to i - 3.
            WAIT UNTIL TRUE.
        } else {
            SET releaseCount to releaseCount + 1.

            if releaseCount > 5
            { 
                print "[{0}]::{1} Released {2} -- {3} > .4 - Score raw: {4} - Raw Length: {5}":format(i:tostring():padleft(6), Time:seconds:tostring():substring(0, 11), lastChar, scoreH, score, inputBuffer:length).
                SET releaseFrame to 101.
                SET keyPressed to -1.
                SHIP:CONNECTION:SENDMESSAGE(lastChar + "Released").
            } else { 
                SET i to i - 5.
            }
        }
    }
    if i = 100 {
        SET i to 0.
    }
    
    if releaseFrame = 101 {
        SET keyPressed to TERMINAL:input:getChar().
        if pressMapToReleaseName:haskey(keyPressed) { 
            SET keyPressed to pressMapToReleaseName[keyPressed].
        }

        print "[{0}]::{1} Pressed {2}":format(i:tostring():padleft(6), Time:seconds:tostring():substring(0, 11), keyPressed).
        SET releaseFrame to CHOOSE i + deadFrameBuffer if i < 95 else i + deadFrameBuffer - 100.
        SET lastChar to keyPressed.
        SHIP:CONNECTION:SENDMESSAGE(lastChar).
        SET releaseCount to 0.
    }

    // clearScreen.
    WAIT UNTIL TRUE.
}

// LIST PROCESSORS IN ALL_PROCESSORS.
// PRINT "HELLO:".
// PRINT ALL_PROCESSORS[0]:name.
// PRINT ALL_PROCESSORS[0]:name.
// PRINT ALL_PROCESSORS[1]:name.
// PRINT ALL_PROCESSORS[1]:allactionnames().
// PRINT ALL_PROCESSORS[1]:alleventnames().


// ALL_PROCESSORS[0]:DOEVENT("Open Terminal").
// ALL_PROCESSORS[1]:DOEVENT("Open Terminal").

// SET P TO ALL_PROCESSORS[1].

// IF SHIP:CONNECTION:SENDMESSAGE("hello") {
//   PRINT "Message sent!".
// }
// PRINT ALL_PROCESSORS[1].


