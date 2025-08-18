RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/__init__.ks".
RUN "0:/generic/terminal/layouts/__init__.ks".
RUN "0:/generic/terminal/composite_widgets/__init__.ks".

// LOCAL __file__ is "0:/generic/terminal/testing.ks".
// FUNCTION App {
//     parameter cols is 120, rows is 50.

//     SET SELF to LEX().
//     SELF:ADD("init", { 
//         SET TERMINAL:WIDTH TO cols.
//         SET TERMINAL:height TO rows.
//     }).
// }

// FUNCTION Class {
//     parameter 
//         className,
//         type is className
//         .
 
//     SET SELF to LEX().
    
//     SELF:ADD("__name__", className).
//     SELF:ADD("__type__", type).

//     return SELF.
// }

// FUNCTION SubClass {
//     parameter 
//         type,
//         baseClass
//         .
 
//     // can we accept the delegate of the function type to do magic?
//     SET SELF to Class(baseClass).
    
//     SET SELF["__name__"] to "{0}[{1}]":format(type, baseClass).
//     SELF:ADD("__type__", type).
// }



clearScreen.

LOCAL hLayout to LAYOUTS:HorizontalLayout(
    LIST(
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER(),
        COMPOSITE_WIDGETS:HEADER()
    )
):render().

// Lil example to show how easy it is to update the widgets
// This only replaces the numbers in the FPS widgets, so no re-render of everything.
LOCAL i to 0.
LOCAL x to 0.
LOCAL y to 0.
UNTIL false { 
    hLayout:widgets[x]:FPS:set(i).
    if x = hLayout:widgets:length - 1 { 
        SET x to 0.
    } else { 
        SET x to x + 1.
    }

    SET i to i + 1.
    if i = 100 {
        SET i to 0.
        SET y to y + 1.
    }
    if y = 10 {
        break.
    }
}

WAIT 5.


// LOCAL l to LABELS:Label("Engine Angles:").
// LAYOUTS:VerticalLayout(
    // LIST(
        // header,
        // l
    // )
// ).
// :render().

// print l:row.
// print l:col.

// for i in range(0, 60) {
//     header:FPS:set(i:toString()).
// }

// for i in range(0, 20) {
//     COMPOSITE_WIDGETS:HEADER():render():FPS:set("60").
//     // Hack to reset the positions since I'm not using my layouts
//     NEXT_LAYOUT_ROW().
//     RESET_COLUMN().
//     RESET_LAYOUT_COLUMN().
// }
// WAIT 10.

// VerticalLayout(
//     List(
//         LABELS:NameLabel("Brandon"),
//         LABELS:NameLabel("Logan"),
//         LABELS:NameLabel("Another guy"),
//         LABELS:Label("==================")
//     )
// )
// :compose().


// Layouts:VerticalLayout(
//     List(
//         LABELS:NameLabel("Brandon 2"),
//         LABELS:NameLabel("Logan 2")
//         // LABELS:NameLabel("Another guy 2"),
//         // LABELS:Label("==================")
//     )
// ):compose().

// print LABELS:NameLabel("Brandon 2"):keys().

// print layoutT:widgets[0]:col.
// print layoutT:widgets[0]:row.
// print layoutT:widgets[0]:width.
// print layoutT:widgets[0]:height.

// print layoutT:widgets:length.
// print layoutT:dimensions().


// print layout:maxCol.
// print layout:maxRow.
// print layout:minCol.
// print layout:minRow.
// LOCAL a to NEXT_ROW(). // Bump next row since Program Ended ruins my screenshots.
// LOCAL b to NEXT_ROW(). // Bump next row since Program Ended ruins my screenshots.

// LOCAL brandonNameLabel to LABELS:NameLabel()
//     :name:set("Brandon")
//     :render().

// LOCAL loganNameLabel to LABELS:NameLabel("Logan")
//     :render().

// loganNameLabel
//     :name:set("Logan I")
//     :render().

// brandonNameLabel
//     :name:set("Brandon I")
//     :render().



Function Screen { 
    parameter layouts.
    SET SELF to LEX().
    SELF:ADD("test", "123").

    SELF:ADD("compose", {
        for layout in layouts {
            layout:compose().
        }
    }).
}

FUNCTION CustomScreen { 
    SET SELF to Screen(
        Label("I am {0}.", 0, 1)
    ).
}

// RUNPATH("0:/generic/terminal/testing.ks").
// toggleflybywire
