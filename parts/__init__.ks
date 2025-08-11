FUNCTION __LOAD_ROTOR { 
    RUN "0:/parts/rotor/__init__.ks".
    return LEX(
        "Rotor",             Rotor@,
        "RotorSettings",     RotorSettings@,
        "ShipRotorMap",      ShipRotorMap@,
        "sync_rotor_angles", sync_rotor_angles@,
        "set_rotors_angles", set_rotors_angles@
    ).
}.

FUNCTION __LOAD_CONTROL_SURFACES {
    RUN "0:/parts/control_surface/__init__.ks".
    return LEX(
        "ControlSurface",    ControlSurface@,
        "ControlSurfaceMap", ControlSurfaceMap@
    ).
}

GLOBAL PARTS IS LEX(
    "ROTOR",            __LOAD_ROTOR(),
    "CONTROL_SURFACES", __LOAD_CONTROL_SURFACES()
).


// example usage:
// PARTS:ROTOR:Rotor().
// PARTS:ROTOR:RotorSettings().
// PARTS:ROTOR:ShipRotorMap().
// PARTS:ROTOR:sync_rotor_angles().
// PARTS:ROTOR:set_rotor_angles().