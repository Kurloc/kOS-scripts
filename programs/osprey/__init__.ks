FUNCTION __load_services_ctrl_surface_service { 
    RUN "0:/programs/osprey/services/control_surface_service.ks".
    return SynchronizedControlSurfaceSerivce@.
}
FUNCTION __load_engine_service { 
    RUN "0:/programs/osprey/services/engine_service.ks".
    return EngineSerivce@.
}
FUNCTION __load_rotor_service {
    RUN "0:/programs/osprey/services/rotor_service.ks".
    return SynchronizedRotorSerivce@.
}
FUNCTION __load_terminal_service { 
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return TerminalService@.
}
FUNCTION __load_console_ui { 
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return ConsoleUITemplate@.
}
FUNCTION __load_rlsr {
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _UPDATE_ROTOR_LOCK_STATUS_READOUT@.
}
FUNCTION __load_rar {
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _UPDATE_ROTOR_ANGLE_READOUT@.
}
FUNCTION __load_vtr { 
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _UPDATE_VTOL_CTRLS_READOUT@.
}
FUNCTION __load_radsr { 
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _UPDATE_ROTOR_ANGLE_DELTA_STRENGTH_READOUT@.
}
FUNCTION __load_cslsr { 
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _UPDATE_CTRL_SURFACES_LOCK_STATUS_READOUT@.
}
FUNCTION __load_setup {
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _setup_readout@.
}
FUNCTION __load_engine_ign {
    runOncePath("0:/programs/osprey/services/terminal.ks").
    return _update_engine_ignition_readout@.
}

GLOBAL OSPREY IS LEX(
    "services", LEX(
        "SynchronizedControlSurfaceSerivce", __load_services_ctrl_surface_service(),
        "EngineService", __load_engine_service(),
        "SynchronizedRotorSerivce", __load_rotor_service(),
        "TERMINAL", LEX(
            "TerminalService", __load_terminal_service(),
            "ConsoleUITemplate", __load_console_ui(),
            "UPDATE", LEX(
                "ROTOR_LOCK_STATUS_READOUT", __load_rlsr(),
                "ROTOR_ANGLE_READOUT", __load_rar(),
                "VTOL_CTRLS_READOUT", __load_vtr(),
                "ROTOR_ANGLE_DELTA_STRENGTH_READOUT", __load_radsr(),
                "CTRL_SURFACES_LOCK_STATUS_READOUT", __load_cslsr(),
                "SETUP_READOUT", __load_setup(),
                "ENGINE_IGNITION", __load_engine_ign()
            )
        )
    )
).

// print OSPREY.
