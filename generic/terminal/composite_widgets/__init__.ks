FUNCTION __LOAD_HEADER {
    RUN "0:/generic/terminal/composite_widgets/header.ks".

    return Header@.
}

GLOBAL COMPOSITE_WIDGETS IS LEX(
    "Header",           __LOAD_HEADER()
).
