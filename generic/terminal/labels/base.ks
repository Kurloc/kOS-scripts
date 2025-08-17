RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/base/__init__.ks".

FUNCTION Label {
    parameter 
        text to "placeholder...",
        col to -1,
        row to NEXT_ROW(),
        width to 40,
        height to 1
    .

    if col = -1 {
        SET col to NEXT_COLUMN(width).
    }

    LOCAL SELF_L to TerminalBase:Widget(col, row).
    SELF_L:ADD("width", width).
    SELF_L:ADD("height", height).
    SELF_L:ADD("text", text).

    FUNCTION _render {
        parameter data is LIST().
        SET d to data.
        if data:length = 0 {
            print SELF_L:text:padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 1 {
            print SELF_L:text:format(d[0]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 2 {
            print SELF_L:text:format(d[0], d[1]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 3 {
            print SELF_L:text:format(d[0], d[1], d[2]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 4 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 5 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3], d[4]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        else if data:length = 6 {
            print SELF_L:text:format(d[0], d[1], d[2], d[3], d[4], d[5]):padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        }
        print SELF_L["text"]:padright(SELF_L:width) at (SELF_L:col, SELF_L:row).
        return SELF_L.
    }

    SELF_L:ADD("render", _render@).

    return SELF_L.
}
