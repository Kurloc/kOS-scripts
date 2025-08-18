RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/base/__init__.ks".

FUNCTION Label {
    parameter 
        text to "placeholder...",
        col to 0,
        row to 0,
        width to 40,
        height to 1
    .

    LOCAL SELF_L to TerminalBase:Widget(col, row, width, height).
    SELF_L:ADD("text", text).

    // overrides
    SET SELF_L:widgetName to "Label[Widget]".
    SET SELF_L:width to SELF_L:text:length.
    
    FUNCTION _render {
        parameter data is LIST().
        SET d to data.
        LOCAL w to SELF_L:text:length().
        if SELF_L:width:typename = "Lexicon" { 
            // SELF_L:width:set(SELF_L:text:length(), False).
            SET w to SELF_L:width:get().
        } else { 
            SET SELF_L:width to SELF_L:text:length().
        }
        
        // print "w: {0}::{1}, c: {2}::{3}, r: {4}::{5}":format(
        //     w, w:typename,
        //     SELF_L:col, SELF_L:col:typename,
        //     SELF_L:row, SELF_L:row:typename
        // ).
        if data:length = 0 {
            print SELF_L:text:padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 1 {
            print SELF_L:text:format(d[0]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 2 {
            print SELF_L:text:format(d[0], d[1]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 3 {
            print SELF_L:text:format(d[0], d[1], d[2]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 4 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 5 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3], d[4]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 6 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3], d[4], d[5]):padright(w) at (SELF_L:col, SELF_L:row).
        }
        print SELF_L["text"]:padright(w) at (SELF_L:col, SELF_L:row).
        return SELF_L.
    }

    SELF_L:ADD("render", _render@).

    return SELF_L.
}
