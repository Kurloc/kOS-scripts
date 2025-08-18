RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/base.ks".

Function FillerLabel {
    parameter
        labelTemplate is "═",
        autoRender is True,
        col to 0,
        row to 0,
        width to 0,
        height to 1
    .
    
    LOCAL SELF_R_LABEL to Label(
        "",
        col,
        row,
        width,
        height
    ).
    SET SELF_R_LABEL:width to Reactive(
        SELF_R_LABEL, 
        autoRender, 
        width
    ).

    SELF_R_LABEL:ADD("labelTemplate", labelTemplate).
    SET SELF_R_LABEL:widgetName to "FillerLabel[Widget]".

    FUNCTION _update {
        SET SELF_R_LABEL:text to repeat(SELF_R_LABEL:labelTemplate, SELF_R_LABEL:width:get()).
        return SELF_R_LABEL.
    }
    SELF_R_LABEL:ADD("update", _update@).
    SELF_R_LABEL:update().
    // print "W CHECK: " + SELF_R_LABEL:width:get():typename.

    return SELF_R_LABEL.
}
