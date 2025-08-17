RUN "0:/generic/terminal/utility.ks".

FUNCTION Widget {
    parameter 
        col to NEXT_COLUMN(), 
        row to NEXT_ROW().
    // print "creating widget with row of " + row.
    LOCAL SELF_W is LEX().

    SELF_W:ADD("row", row).
    SELF_W:ADD("col", col).
    // could be good for user override eventually?
    //  get_content_width()
    //  get_content_height().

    return SELF_W.
}