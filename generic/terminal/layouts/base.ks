Function Layout {
    parameter widgets is List().

    LOCAL SELF to LEX().
    // LOCAL PRIVATES to LEX().
    SELF:ADD("widgets", widgets).

    // find dimensions
    SET maxRow to 0.
    SET maxCol to 0.
    SET minRow to 0.
    SET minCol to 0.

    for widget in widgets { 
        SET maxCol to max(maxCol, widget:width).
        SET maxRow to max(maxRow, widget:height).
        SET minCol to min(minCol, widget:width).
        SET minRow to min(minRow, widget:height).
    }
    SELF:ADD("maxCol", maxCol).
    SELF:ADD("maxRow", maxRow).
    SELF:ADD("minCol", minCol).
    SELF:ADD("minRow", minRow).

    FUNCTION _compose {
        for widget in widgets { 
            widget:render().
        }

        return SELF.
    }
    FUNCTION _dimensions {
        return LIST(
            V(SELF:minCol, SELF:minRow, 0),
            V(SELF:maxCol, SELF:maxRow, 0)
        ).
    }
    SELF:ADD("compose", _compose@).
    SELF:ADD("dimensions", _dimensions@).

    return SELF.
}
