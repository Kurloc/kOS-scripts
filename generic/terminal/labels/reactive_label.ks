RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/base.ks".

Function ReactiveLabel {
    parameter
        labelTemplate is "{{text}}",
        dataLex is Lex("text", "placeholder"),
        autoRender is True,
        col to 0,
        row to 0,
        width to 40,
        height to 1
    .

    LOCAL SELF_R_LABEL to Label(
        "",
        col,
        row,
        width,
        height
    ).
    { 
        for kkk in dataLex:keys { 
            SELF_R_LABEL:ADD(kkk, Reactive(SELF_R_LABEL, autoRender, dataLex[kkk])).
        }
    }

    SELF_R_LABEL:ADD("labelTemplate", labelTemplate).
    SET SELF_R_LABEL:widgetName to "ReactiveLabel[Widget]".

    FUNCTION _update {
        SET SELF_R_LABEL:text to KFormat(SELF_R_LABEL, SELF_R_LABEL:labelTemplate).
        SET SELF_R_LABEL:width to SELF_R_LABEL:text:length.
        return SELF_R_LABEL.
    }
    SELF_R_LABEL:ADD("update", _update@).
    SELF_R_LABEL:update().

    return SELF_R_LABEL.
}
