// @TODO Optimize string usage as much as possible here
// @TODO Get this in a function at least so it's not an import bomb waiting to go off.
LOCAL i to 0.

local keyPress to -1.
local queuePresses to Lex().
UNTIL FALSE {
    SET i to i + 1.
    if not TERMINAL:input:hasChar {
        if keyPress <> -1 { 
            SET keyPress to -1.
        }
    } 
    else { 
        SET keyPress to "".
        UNTIL not TERMINAL:input:hasChar {
            LOCAL newChar to TERMINAL:input:getChar().
            if newChar = " " {
                queuePresses:add(queuePresses:length, keyPress).
                SET keyPress to "".
            } else { 
                print "[{0}::{1}] Char: {2}":format(i:toString(), queuePresses:length, newChar).
                SET keyPress to keyPress + newChar.
            }
        }
        if queuePresses:keys:length = 0 { 
            queuePresses:add(0, keyPress).
        }

        for y in range(0, queuePresses:length) { 
            SET k to queuePresses[y].
            print "[{0}]::{1} Pressed {2}":format(i:tostring():padleft(6), Time:seconds:tostring():substring(0, 11), k).
            SHIP:CONNECTION:SENDMESSAGE(k).
        }
        queuePresses:clear().
    }

    if i = 100 {
        SET i to 0.
    }
    WAIT UNTIL TRUE.
}
