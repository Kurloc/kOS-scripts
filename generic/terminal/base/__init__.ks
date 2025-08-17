FUNCTION __LOAD_WIDGET { 
    RUN "0:/generic/terminal/base/widget.ks".
    return Widget@.
}.

GLOBAL TerminalBase IS LEX(
    "Widget", __LOAD_WIDGET()
).
