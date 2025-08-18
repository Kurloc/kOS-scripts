RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/base.ks".

Function NameLabel {
    parameter
        defaultName is "placeholder",
        autoRender is True,
        col to 0,
        row to 0,
        width to 40,
        height to 1
    .

    LOCAL SELF_N to Label(
        defaultName,
        col,
        row,
        width,
        height
    ).
    
    SELF_N:ADD("name", Reactive(SELF_N, autoRender, defaultName)).
    SET SELF_N:widgetName to "NameLabel[Widget]".

    FUNCTION _update {
        SET SELF_N:text to KFormat(SELF_N, "hello {{name}}").
        SET SELF_N:width to SELF_N:text:length.
        return SELF_N.
    }
    SELF_N:ADD("update", _update@).
    SELF_N:update().

    // print SELF_N:keys.
    return SELF_N.
}
