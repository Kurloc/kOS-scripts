RUN "0:/generic/terminal/utility.ks".

FUNCTION Widget {
    parameter 
        col to NEXT_COLUMN(), 
        row to NEXT_ROW(),
        width to 20,
        height to 1.
    // print "creating widget with row of " + row.
    LOCAL SELF_W is LEX().

    SELF_W:ADD("row", row).
    SELF_W:ADD("col", col).
    SELF_W:ADD("width", width).
    SELF_W:ADD("height", height).
    SELF_W:ADD("widgetName", "Widget").
    // could be good for user override eventually?
    //  get_content_width()
    //  get_content_height().

    return SELF_W.
}