Function Layout {
    parameter widgets is List().

    LOCAL t to widgets.
    // print widgets[0]:keys().
    LOCAL SELF_LAYOUT to LEX().
    SELF_LAYOUT:ADD("OffSetScope", OffSetScope()).
    // LOCAL PRIVATES to LEX().
    // SELF_LAYOUT:ADD("widgets", widgets).

    // find dimensions
    LOCAL maxRow to 0.
    LOCAL maxCol to 0.
    LOCAL minRow to 0.
    LOCAL minCol to 0.
    LOCAL fillerWidgets to List().
    LOCAL fixedWidthWidgets to List().
    LOCAL layouts to List().
    for widget in widgets {
        if widget:hasKey("layout") { 
            SET widget:layout:OffSetScope to SELF_LAYOUT:OffSetScope.
            SET widget:layout:isRoot      to false.
            widget:layout:reCalcSize().
            layouts:add(widget:layout).
        }
        if widget:widgetName = "FillerLabel[Widget]" { 
            fillerWidgets:add(widget).
        } else {
            fixedWidthWidgets:add(widget).
        }
        SET maxCol to max(maxCol, widget:width).
        SET maxRow to max(maxRow, widget:height).
        SET minCol to min(minCol, widget:width).
        SET minRow to min(minRow, widget:height).
    }
    SELF_LAYOUT:ADD("isRoot",   true).
    SELF_LAYOUT:ADD("isLayout", true).
    SELF_LAYOUT:ADD("maxCol", maxCol).
    SELF_LAYOUT:ADD("maxRow", maxRow).
    SELF_LAYOUT:ADD("minCol", minCol).
    SELF_LAYOUT:ADD("minRow", minRow).
    SELF_LAYOUT:ADD("widgets",               widgets).
    SELF_LAYOUT:ADD("fillerWidgets",         fillerWidgets).
    SELF_LAYOUT:ADD("fixedWidthWidgets",     fixedWidthWidgets).
    SELF_LAYOUT:ADD("layouts",               layouts).
    SELF_LAYOUT:ADD("reCalcSize",            {return SELF_LAYOUT.}).
    SELF_LAYOUT:ADD("hasSizeBeenCalculated", false).

    FUNCTION _compose {
        if not SELF_LAYOUT:hasSizeBeenCalculated {
            SELF_LAYOUT:reCalcSize().
        }

        for w in SELF_LAYOUT:widgets { 
            w:render().
        }

        return SELF_LAYOUT.
    }
    FUNCTION _dimensions {
        return LIST(
            V(SELF_LAYOUT:minCol, SELF_LAYOUT:minRow, 0),
            V(SELF_LAYOUT:maxCol, SELF_LAYOUT:maxRow, 0)
        ).
    }
    SELF_LAYOUT:ADD("compose", _compose@).
    SELF_LAYOUT:ADD("render", _compose@).
    SELF_LAYOUT:ADD("dimensions", _dimensions@).

    return SELF_LAYOUT.
}
