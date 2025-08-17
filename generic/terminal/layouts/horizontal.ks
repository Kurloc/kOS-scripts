RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/layouts/base.ks".

FUNCTION HorizontalLayout {
    parameter widgets is List().
    
    LOCAL SELF to Layout(widgets).
    SET layoutColumn to NEXT_LAYOUT_COLUMN(SELF:maxCol - 1).
    SET layoutRow    to NEXT_LAYOUT_ROW(0).

    for widget in SELF:widgets {
        SET widget:col to layoutColumn + widget:col.
        SET widget:row to layoutRow.
    }

    return SELF.
}
