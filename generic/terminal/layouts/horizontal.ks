RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/layouts/base.ks".

FUNCTION HorizontalLayout {
    parameter hWidgets is List(),
              hWidth is 25.

    LOCAL SELF_HORIZONTAL_LAYOUT to Layout(hWidgets).
    SELF_HORIZONTAL_LAYOUT:ADD("colOffset", 0).
    SET SELF_HORIZONTAL_LAYOUT:reCalcSize to {
        parameter 
            layoutColumn is SELF_HORIZONTAL_LAYOUT:OffSetScope:NEXT_LAYOUT_COLUMN(SELF_HORIZONTAL_LAYOUT:colOffset + hWidth),
            layoutRow    is SELF_HORIZONTAL_LAYOUT:OffSetScope:NEXT_LAYOUT_ROW(0).

        // print layoutColumn.
        // print layoutRow.
        // print SELF_HORIZONTAL_LAYOUT:isRoot.
        if SELF_HORIZONTAL_LAYOUT:isRoot { 
            SELF_HORIZONTAL_LAYOUT:OffSetScope:RESET_LAYOUT_COLUMN().
            SELF_HORIZONTAL_LAYOUT:OffSetScope:RESET_LAYOUT_ROW().
            SET layoutColumn to SELF_HORIZONTAL_LAYOUT:OffSetScope:NEXT_LAYOUT_COLUMN(MAX(SELF_HORIZONTAL_LAYOUT:maxCol - 1, hWidth)).
            SET layoutRow    to SELF_HORIZONTAL_LAYOUT:OffSetScope:NEXT_LAYOUT_ROW(SELF_HORIZONTAL_LAYOUT:maxRow).
        }

        // print layoutColumn.
        // print layoutRow.
        // print SELF_HORIZONTAL_LAYOUT:maxCol.
        LOCAL spaceFilled is 0.
        for hWidgetSpace in hWidgets {
            if hWidgetSpace:hasKey("layout") { 
                SET hWidgetSpace:layout:isRoot to false.
            }
            if hWidgetSpace:widgetName = "FillerLabel[Widget]" { 
                SET spaceFilled to spaceFilled + hWidgetSpace:width:get().
            } else {
                SET spaceFilled to spaceFilled + hWidgetSpace:width.
            }
        }

        LOCAL spaceToFill is MAX(
            hWidth, 
            SELF_HORIZONTAL_LAYOUT:maxCol / 1
        ) - spaceFilled.
        // print spaceToFill.

        LOCAL rowOffset to layoutRow.
        LOCAL colOffset to layoutColumn.
        for hWidget in hWidgets {
            SET hWidget:col to colOffset.
            SET hWidget:row to layoutRow.

            if hWidget:widgetName = "FillerLabel[Widget]" {
                hWidget:width:set(spaceToFill, true).
                // print "new width: {0}":format(hWidget:width:get()).
                SET colOffset to colOffset + spaceToFill.
            } else {
                // print hWidget:width:typename + " - " + colOffset:typename + " - " + hWidget:widgetName.
                if hWidget:width:typename = "Lexicon" and hWidget:width:hasKey("get") {
                    // print "They got me doe: " + hWidget:widgetName.
                    SET colOffset to colOffset + hWidget:width:get().
                } else if hWidget:width:typename = "Scalar" { 
                    SET colOffset to colOffset + hWidget:width.
                    SET SELF_HORIZONTAL_LAYOUT:colOffset to colOffset.
                } else {
                    print "wtf did you come from though?".
                }
            }
            // print "{0} :: {1}-{2}":format(hWidget:widgetName, hWidget:col, colOffset).
        }
    
        for ly in SELF_HORIZONTAL_LAYOUT:layouts {
            ly:reCalcSize().
        }
    }.

    return SELF_HORIZONTAL_LAYOUT.
}
