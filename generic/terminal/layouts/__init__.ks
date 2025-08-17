LOCAL __LOAD_LAYOUT is { 
    RUN "0:/generic/terminal/layouts/base.ks".
    return Layout@.
}.
LOCAL __LOAD_HORIZONTAL_LAYOUT is { 
    RUN "0:/generic/terminal/layouts/horizontal.ks".
    return HorizontalLayout@.
}.
LOCAL __LOAD_VERT_LAYOUT is { 
    RUN "0:/generic/terminal/layouts/vertical.ks".
    return VerticalLayout@.
}.

GLOBAL Layouts IS LEX(
    "Layout",           __LOAD_LAYOUT(),
    "HorizontalLayout", __LOAD_HORIZONTAL_LAYOUT(),
    "VerticalLayout",   __LOAD_VERT_LAYOUT()
).


// example usage:
// PARTS:ROTOR:Rotor().
// PARTS:ROTOR:RotorSettings().
// PARTS:ROTOR:ShipRotorMap().
// PARTS:ROTOR:sync_rotor_angles().
// PARTS:ROTOR:set_rotor_angles().