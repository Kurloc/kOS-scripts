
// ▄ █ ▀ 

// ▄
// ▄▄
//  █
// ▀▀
// ▀

FUNCTION padLeft {
    parameter str, padAmount, fillCharr to " ".
    // print "A: {0}, {1}, {2}":format(str, padAmount, fillCharr).
    if padAmount = 0 {
        return str.
    }

    until str:length = padAmount { 
        SET str to fillCharr + str.
    }

    return str.
}


print "test: {0}":format(padLeft("abc", 15, "~")).

clearScreen.
LOCAL wheel to List("▄ ", " ▄", " ▀", "▀ ").
LOCAL wheel2 to List("▄▄", " █", "▀▀", "█ ").
LOCAL empty to "░".
LOCAL filledChar to "▓".
LOCAL amtFilled to 0.

LOCAL ii to 0.
LOCAL i to 0.
print "" at (0, 10).
UNTIL false {
    print "Frame: {0} :: {1}":format(i, amtFilled) at (0, 0).
    // print wheel[ii]:toString():padleft(amtFilled) at (0, 10).
    print padleft(wheel[ii]:toString(), amtFilled, filledChar) at (0, 10).

    if i = 15 { 
        SET amtFilled to 3.
    }
    if i = 40 { 
        SET amtFilled to 4.
    }
    if i = 120 { 
        SET amtFilled to 8.
    }
    if i = 200 { 
        SET amtFilled to 10.
    }
    if i = 300 { 
        SET amtFilled to 14.
    }
    if i = 400 { 
        SET amtFilled to 16.
    }
    if i = 500 { 
        SET amtFilled to 18.
    }
    if i = 600 { 
        SET amtFilled to 20.
    }

    if ii = 3 { 
        SET ii to 0.
    } else { 
        set ii to ii + 1.
    }

    SET i to i + 1.
    WAIT .0325.
}
