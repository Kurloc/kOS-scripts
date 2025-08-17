LOCAL FILLED_BLOCK is "█".
LOCAL EMPTY_BLOCK is "░".

FUNCTION ProgressBar { 
    parameter lineIndex, startPosition, width, initialFillPercent to 0.

    LOCAL SELF to LEX().
    LOCAL progressBarString to "".
    LOCAL btf is width * initialFillPercent.
    for i in range(0, width) {
        if i <= btf { 
            SET progressBarString to progressBarString + FILLED_BLOCK.   
        } else {          
            SET progressBarString to progressBarString + EMPTY_BLOCK.   
        }
    }

    // Fields.
    SELF:ADD("lineIndex",     lineIndex).
    SELF:ADD("startPosition", startPosition).
    SELF:ADD("width",         width).
    SELF:ADD("progressBarString", progressBarString).
    SELF:ADD("render", {
        // This is just to init the progress bar, it will only ever render an empty progress bar for the ProgresBar's defined width.
        PRINT SELF:progressBarString AT (SELF:startPosition, SELF:lineIndex).

        return SELF.
    }).
    SELF:ADD("update", {
        parameter percentFilled.
        // Update a progress bar's rendering in place in the terminal w/o doing any string manipulation directly. 
        // I hope this avoids more allocs :D

        LOCAL percString to percentFilled:toString().
        LOCAL blocksToFill is FLOOR(width * (percentFilled / 100)).
        for i in range(0, SELF:progressBarString:length) { 
            if i < blocksToFill {
                PRINT FILLED_BLOCK AT (SELF:startPosition + i, SELF:lineIndex).
            } else {
                // if i < blocksToFill + percentFilled:toString():length { 
                    // PRINT percString[i - blocksToFill] AT (SELF:startPosition + i, SELF:lineIndex).
                // } else { 
                PRINT EMPTY_BLOCK AT (SELF:startPosition + i, SELF:lineIndex).
                // }
            }
        }

        return SELF.
    }).

    return SELF.
}

// clearscreen.
// print "Throttle Engine #1: ░░░░░░░░░░░░░░░░░░░░".
// print "Throttle Engine #2: ░░░░░░░░░░░░░░░░░░░░".
// print "Throttle Engine #3: ░░░░░░░░░░░░░░░░░░░░".
// print "Throttle Engine #4: ░░░░░░░░░░░░░░░░░░░░".
// LOCAL pb1 to ProgressBar(0, 20, 20):render():update(10).
// LOCAL pb2 to ProgressBar(1, 20, 20):render():update(50).
// LOCAL pb2 to ProgressBar(2, 20, 20):render():update(75).
// LOCAL pb2 to ProgressBar(3, 20, 20):render():update(100).


// Console Becomes this:
// print "Throttle Engine #1: ██░░░░░░░░░░░░░░░░░░".
// print "Throttle Engine #2: ██████████10%░░░░░░░".
// print "Throttle Engine #3: ███████████████░░░░░".
// print "Throttle Engine #4: ████████████████████".