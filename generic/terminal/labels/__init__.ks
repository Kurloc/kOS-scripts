FUNCTION __LOAD_LABEL { 
    RUN "0:/generic/terminal/labels/base.ks".
    return Label@.
}.
FUNCTION __LOAD_NAME_LABEL { 
    RUN "0:/generic/terminal/labels/name_label.ks".
    return NameLabel@.
}.
FUNCTION __LOAD_REACTIVE_LABEL { 
    RUN "0:/generic/terminal/labels/reactive_label.ks".
    return ReactiveLabel@.
}.
FUNCTION __LOAD_FILLER_LABEL { 
    RUN "0:/generic/terminal/labels/filler_label.ks".
    return FillerLabel@.
}.

GLOBAL LABELS IS LEX(
    "Label",           __LOAD_LABEL(),
    "NameLabel",       __LOAD_NAME_LABEL(),
    "ReactiveLabel",   __LOAD_REACTIVE_LABEL(),
    "FillerLabel",   __LOAD_FILLER_LABEL()
).


// example usage:
// PARTS:ROTOR:Rotor().
// PARTS:ROTOR:RotorSettings().
// PARTS:ROTOR:ShipRotorMap().
// PARTS:ROTOR:sync_rotor_angles().
// PARTS:ROTOR:set_rotor_angles().