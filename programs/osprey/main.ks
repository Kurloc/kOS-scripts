RUN "0:/generic/event_bus.ks".
RUN "0:/generic/progress_bar.ks".
RUN "0:/parts/__init__.ks".
RUN "0:/programs/osprey/constants.ks".
RUN "0:/programs/osprey/__init__.ks".

FUNCTION update {
    parameter 
        synchRotorservice,
        synchCtrlSurfaceService,
        engineService,
        uiService,
        eb
        .

    // Really not sure why the reference seems to be the wrong one?
    // TODO: figure it out dawg.
    SET uiService:eventBus to eb.
    SET synchRotorservice:eventBus to eb.
    SET synchCtrlSurfaceService:eventBus to eb.
    SET engineService:eventBus to eb.

    LOCAL start to Time:SECONDS.
    // FPS debug
    // LOCAL startF2F to Time:SECONDS.
    // LOCAL waitTime to 0.
    // LOCAL frameTimeCap to 1 / 120.

    LOCAL physicsTick to 0.
    LOCAL sum to 0.

    UNTIL FALSE {
        local pitchInput to SHIP:control:pilotpitch.

        synchRotorService:on_update(
            pitchInput,
            physicsTick
        ).
        synchCtrlSurfaceService:on_update().
        // engineService:on_update().

        SET physicsTick to physicsTick + 1.

        // SET timeThisFrame to TIME:seconds - startF2F.
        // SET waitTime to CHOOSE (frameTimeCap - timeThisFrame) IF timeThisFrame < frameTimeCap ELSE 0.
        if MOD(physicsTick, 30) {
            SET sum to (TIME:Seconds - start).
            PRINT "FPS: " + FLOOR((1 / (sum / 30)) / 10):tostring():padleft(15) AT (0, 40).
            // print timeThisFrame:toString():padleft(8) AT (0, 41).
            // print waitTime:toString():padleft(8) AT (0, 42).
            // print frameTimeCap:toString():padleft(8) AT (0, 43).
            SET start to TIME:seconds.
        }
        
        // SET startF2F to TIME:Seconds.
        // WAIT waitTime.
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
    LOCAL ENGINE_MAP          to PARTS:ENGINE:EngineMap().
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
    SET NUMBER_OF_ROTORS  to LEX("value", ROTOR_MAP:rotors:length).
    SET NUMBER_OF_ENGINES to LEX("value", ENGINE_MAP:engines:length).
    
    LOCAL rotorAngleDeltaStrengthProgressBar to ProgressBar(
        (NUMBER_OF_ROTORS:value * 2 ) + HEADER_OFFSET + 7,
        27, 
        16,
        100
    ).

    LOCAL EVENT_BUS to EventBus().
    EVENT_BUS:register(EVENT_CTRL_SURFACE_LOCK_STATUS_CHANGE,   LIST(OSPREY:SERVICES:TERMINAL:UPDATE:CTRL_SURFACES_LOCK_STATUS_READOUT)).        
    EVENT_BUS:register(EVENT_ROTOR_ANGLE_DELTA_STRENGTH_CHANGE, LIST(rotorAngleDeltaStrengthProgressBar:update)).
    EVENT_BUS:register(EVENT_ROTOR_ANGLE_CHANGE,                LIST(OSPREY:SERVICES:TERMINAL:UPDATE:ROTOR_ANGLE_READOUT)).
    EVENT_BUS:register(EVENT_ROTOR_LOCK_STATUS_CHANGE,          LIST(OSPREY:SERVICES:TERMINAL:UPDATE:ROTOR_LOCK_STATUS_READOUT)).
    EVENT_BUS:register(EVENT_VTOL_CONTROLS_ENABLED_CHANGE,      LIST(OSPREY:SERVICES:TERMINAL:UPDATE:VTOL_CTRLS_READOUT)).

    // Services
    LOCAL rotorSvc to OSPREY:SERVICES:SynchronizedRotorSerivce(
        ROTOR_MAP,
        ROTOR_MAP:rotors[0],
        ACTION_GROUP_CACHE,
        EVENT_BUS
    ).
    LOCAL ctrlSurfaceSvc to OSPREY:SERVICES:SynchronizedControlSurfaceSerivce(
        CONTROL_SURFACE_MAP,
        ACTION_GROUP_CACHE,
        EVENT_BUS
    ).
    LOCAL engineSvc to OSPREY:SERVICES:EngineService(ENGINE_MAP, ACTION_GROUP_CACHE, EVENT_BUS).

    LOCAL uiSvc to OSPREY:SERVICES:TERMINAL:TerminalService(
        ConsoleUITemplate(
            LEX(
                "rotorMap", ROTOR_MAP,
                "engineMap", ENGINE_MAP,
                "rotorAngleStrengthProgressBar", rotorAngleDeltaStrengthProgressBar
            ), 
            OSPREY:SERVICES:TERMINAL:UPDATE:SETUP_READOUT
        ),
        EVENT_BUS
    ):initApp().
    
    for i in RANGE(0, NUMBER_OF_ENGINES:value) {
        LOCAL pb to ProgressBar(
            (NUMBER_OF_ROTORS:value * 2 ) + HEADER_OFFSET + 12 + i,
            14, 
            25,
            100
        ).
        pb:update(0).
        EVENT_BUS:register(EVENT_ENGINE_THRUST_CHANGE + i, LIST(pb:update)).
        EVENT_BUS:register(EVENT_ENGINE_TOGGLE + i, LIST(OSPREY:SERVICES:TERMINAL:UPDATE:ENGINE_IGNITION(i))).
    }

    // Update Loop will run until user kills the program
    update(
        rotorSvc,
        ctrlSurfaceSvc,
        engineSvc,
        uiSvc,
        EVENT_BUS
    ).
}

main().