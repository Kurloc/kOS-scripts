RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/layouts/base.ks".

FUNCTION VerticalLayout {
    parameter vWidgets is List().
    
    LOCAL SELF_VERTICAL_LAYOUT to Layout(vWidgets).
    LOCAL layoutColumn to NEXT_LAYOUT_COLUMN(0). // Vert Layouts don't offset the width stacking
    LOCAL layoutRow    to NEXT_LAYOUT_ROW(SELF_VERTICAL_LAYOUT:maxRow - 1).

    for vWidget in SELF_VERTICAL_LAYOUT:widgets {
        SET vWidget:col to layoutColumn.
        SET vWidget:row to layoutRow + vWidget:row.
    }

    return SELF_VERTICAL_LAYOUT.
}
