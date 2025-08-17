RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/layouts/base.ks".

FUNCTION VerticalLayout {
    parameter widgets is List().
    
    LOCAL SELF to Layout(widgets).
    SET layoutColumn to NEXT_LAYOUT_COLUMN(0). // Vert Layouts don't offset the width stacking
    SET layoutRow    to NEXT_LAYOUT_ROW(SELF:maxRow - 1).

    for widget in SELF:widgets {
        SET widget:col to layoutColumn.
        SET widget:row to layoutRow + widget:row.
    }

    return SELF.
}
