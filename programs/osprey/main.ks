RUN "0:/generic/event_bus.ks".
RUN "0:/parts/__init__.ks".
RUN "0:/programs/osprey/constants.ks".
RUN "0:/programs/osprey/services/rotor_service.ks".
RUN "0:/programs/osprey/services/control_surface_service.ks".
RUN "0:/programs/osprey/services/terminal.ks".

FUNCTION update {
    parameter 
        synchRotorservice,
        synchCtrlSurfaceService,
        uiService,
        eb
        .

    // Really not sure why the reference seems to be the wrong one?
    // TODO: figure it out dawg.
    SET uiService:eventBus to eb.
    SET synchRotorservice:eventBus to eb.
    SET synchCtrlSurfaceService:eventBus to eb.
    // LOCAL x to synchRotorservice:rotorMap:rotors[0].
    // print "event bus check: " + eb:events:length. 
    // print "event bus check: " + x:typename.
    // print "event bus check: " + uiService:eventBus:events:keys:length.
    // print "event bus check: " + synchRotorservice:eventBus:events:keys:length.
    // print eb:events[EVENT_ROTOR_ANGLE_CHANGE][0]:typename.
    // eb:events[EVENT_ROTOR_ANGLE_CHANGE][0](x).

    LOCAL physicsTick to 0.
    UNTIL FALSE {
        local pitchInput to SHIP:control:pilotpitch.

        synchRotorService:on_update(
            pitchInput,
            physicsTick
        ).
        synchCtrlSurfaceService:on_update().

        SET physicsTick to physicsTick + 1.
        WAIT UNTIL TRUE.
    }
}

FUNCTION main {
    SWITCH TO 0.

    CLEARSCREEN.
    Print "[INFO] VTOL Handler is booting...".

    // open the terminal
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

    // Setup
    LOCAL EVENT_BUS to EventBus().
    EVENT_BUS:register(EVENT_CTRL_SURFACE_LOCK_STATUS_CHANGE, LIST(UPDATE_CTRL_SURFACES_LOCK_STATUS_READOUT)).        
    EVENT_BUS:register(EVENT_ROTOR_ANGLE_DELTA_STRENGTH_CHANGE, LIST(UPDATE_ROTOR_ANGLE_DELTA_STRENGTH_READOUT)).
    EVENT_BUS:register(EVENT_ROTOR_ANGLE_CHANGE, LIST(UPDATE_ROTOR_ANGLE_READOUT)).
    EVENT_BUS:register(EVENT_ROTOR_LOCK_STATUS_CHANGE, LIST(UPDATE_ROTOR_LOCK_STATUS_READOUT)).
    EVENT_BUS:register(EVENT_VTOL_CONTROLS_ENABLED_CHANGE, LIST(UPDATE_VTOL_CTRLS_READOUT)).

    LOCAL ROTOR_MAP           to PARTS:ROTOR:ShipRotorMap().
    LOCAL CONTROL_SURFACE_MAP to PARTS:CONTROL_SURFACES:ControlSurfaceMap().
    LOCAL ACTION_GROUP_CACHE  to Lexicon(
        "ag1", AG1,
        "ag2", AG2,
        "ag3", AG3,
        "ag4", AG4,
        "ag5", AG5,
        "ag6", AG6,
        "ag7", AG7,
        "ag8", AG8,
        "ag9", AG9,
        "ag10", AG10
    ).
    SET NUMBER_OF_ROTORS      to LEX("value", ROTOR_MAP:length).

    LOCAL rotorSvc to SynchronizedRotorSerivce(
        ROTOR_MAP,
        ROTOR_MAP:rotors[0],
        ACTION_GROUP_CACHE,
        EVENT_BUS
    ).
    LOCAL ctrlSurfaceSvc to SynchronizedControlSurfaceSerivce(
        CONTROL_SURFACE_MAP,
        ACTION_GROUP_CACHE,
        EVENT_BUS
    ).    
    LOCAL uiSvc to TerminalService(
        ConsoleUITemplate(ROTOR_MAP, SETUP_READOUT),
        EVENT_BUS
    ):initApp().

    // Update Loop will run until user kills the program
    update(
        rotorSvc,
        ctrlSurfaceSvc,
        uiSvc,
        EVENT_BUS
    ).
}

main().