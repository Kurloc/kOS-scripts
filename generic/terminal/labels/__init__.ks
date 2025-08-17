FUNCTION __LOAD_LABEL { 
    RUN "0:/generic/terminal/labels/base.ks".
    return Label@.
}.
FUNCTION __LOAD_NAME_LABEL { 
    RUN "0:/generic/terminal/labels/name_label.ks".
    return NameLabel@.
}.

GLOBAL LABELS IS LEX(
    "Label",           __LOAD_LABEL(),
    "NameLabel",       __LOAD_NAME_LABEL()
).


// example usage:
// PARTS:ROTOR:Rotor().
// PARTS:ROTOR:RotorSettings().
// PARTS:ROTOR:ShipRotorMap().
// PARTS:ROTOR:sync_rotor_angles().
// PARTS:ROTOR:set_rotor_angles().