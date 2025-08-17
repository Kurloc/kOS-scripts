RUN "0:/generic/terminal/utility.ks".
RUN "0:/generic/terminal/labels/__init__.ks".

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

// VerticalLayout(
//     List(
//         LABELS:NameLabel("Brandon"),
//         LABELS:NameLabel("Logan"),
//         LABELS:NameLabel("Another guy"),
//         LABELS:Label("==================")
//     )
// )
// :compose().

HorizontalLayout(
    List(
        LABELS:NameLabel("Brandon 2"),
        LABELS:NameLabel("Logan 2")
        // LABELS:NameLabel("Another guy 2"),
        // LABELS:Label("==================")
    )
):compose().

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
