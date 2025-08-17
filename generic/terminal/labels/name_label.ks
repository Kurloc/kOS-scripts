RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/base.ks".

Function NameLabel {
    parameter
        defaultName is "placeholder",
        autoRender is True,
        col to -1,
        row to NEXT_ROW(),
        width to 40,
        height to 1
    .

    if col = -1 {
        SET col to NEXT_COLUMN(width).
    }
    
    LOCAL SELF_N to Label(
        defaultName,
        col,
        row,
        width,
        height
    ).
    
    SELF_N:ADD("name", Reactive(SELF_N, autoRender, defaultName)).
    FUNCTION _update {
        SET SELF_N:text to KFormat(SELF_N, "hello {{name}}.........................").
        return SELF_N.
    }
    SELF_N:ADD("update", _update@).
    SELF_N:update().

    return SELF_N.
}
