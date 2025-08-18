RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/base/__init__.ks".
RUN "0:/generic/terminal/labels/__init__.ks".
RUN "0:/generic/terminal/layouts/__init__.ks".


// "╔══════════════════════════════════(FPS: 00)╗"

FUNCTION Header {
    parameter
        showFpsCounter is true,
        col to -1,
        row to NEXT_ROW(),
        width to 40,
        height to 1
    .

    LOCAL SELF_L to TerminalBase:Widget(col, row, width, height).
    SET SELF_L:widgetName to "Header[Widget]".
    SELF_L:ADD(
        "layout", 
        LAYOUTS:HorizontalLayout(
            List(
                LABELS:Label("╔═"),
                LABELS:Label("[VTOL V1]"),
                LABELS:FillerLabel("═"),
                LABELS:ReactiveLabel("(FPS: {{FPS}})", Lex("FPS", 60)),
                LABELS:Label("╗")
            )
        )
    ).
    
    SELF_L:ADD("FPS", SELF_L:layout:widgets[3]:FPS).
    FUNCTION _render {
        SELF_L:layout:render().
        
        return SELF_L.
    }
    SELF_L:ADD("render", _render@).

    return SELF_L.
}
