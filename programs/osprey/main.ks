RUN "0:/generic/event_bus.ks".
RUN "0:/generic/progress_bar.ks".
RUN "0:/generic/services/terminal_input_service.ks".
RUN "0:/parts/__init__.ks".
RUN "0:/programs/osprey/constants.ks".
RUN "0:/programs/osprey/__init__.ks".

FUNCTION update {
    parameter 
        synchRotorservice,
        synchCtrlSurfaceService,
        engineService,
        uiService,
        terminalInputSvc,
        eb,
        someStateToRefactor
        .

    // Really not sure why the reference seems to be the wrong one?
    // TODO: figure it out dawg.
    SET uiService:eventBus to eb.
    SET synchRotorservice:eventBus to eb.
    SET synchCtrlSurfaceService:eventBus to eb.
    SET engineService:eventBus to eb.
    SET terminalInputSvc:eventBus to eb.

    LOCAL start to Time:SECONDS.
    LOCAL physicsTick to 1.
    LOCAL pitchInput to 0.

    eb:register("w", LIST({SET pitchInput to -1.}, {SET SHIP:CONTROL:PITCH to -1.})).
    eb:register("s", LIST({SET pitchInput to 1.}, {SET SHIP:CONTROL:PITCH to 1.})).
    eb:register("1", LIST({SET AG1 to not AG1.})).
    eb:register("2", LIST({SET AG2 to not AG2.})).
    eb:register("3", LIST({SET AG3 to not AG3.})).
    eb:register("4", LIST({SET AG4 to not AG4.})).
    eb:register("5", LIST({SET AG5 to not AG5.})).
    eb:register("6", LIST({SET AG6 to not AG6.})).
    eb:register("7", LIST({SET AG7 to not AG7.})).
    eb:register("8", LIST({SET AG8 to not AG8.})).
    eb:register("9", LIST({SET AG9 to not AG9.})).
    eb:register("0", LIST({SET AG0 to not AG0.})).

    UNTIL FALSE {
        terminalInputSvc:onUpdate().
        synchRotorService:onUpdate(
            pitchInput,
            physicsTick
        ).
        synchCtrlSurfaceService:onUpdate().
        engineService:onUpdate(physicsTick).

        if MOD(physicsTick, 30) = 0 
        {
            eb:fire1(EVENT_FPS_UPDATE, FLOOR(1 / ((TIME:Seconds - start) / 30))).
            SET start to TIME:seconds.
        }
        SET physicsTick to physicsTick + 1.
        SET pitchInput to 0.
        SET SHIP:CONTROL:PITCH to 0.
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
    SET someStateToRefactor to LEX("pitchInput", 0).
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
    EVENT_BUS:register(EVENT_FPS_UPDATE,                        LIST(OSPREY:SERVICES:TERMINAL:UPDATE:FPS_READOUT)).

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
    LOCAL terminalInputSvc to TerminalInputService(EVENT_BUS).
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
    EVENT_BUS:register(" ",                                     LIST(engineSvc:toggleEngines@)).

    // PRINT (((-90 - -360) / 720) * 100).
    // PRINT (((0 - -360) / 720) * 100).
    // PRINT (((90 - -360) / 720) * 100).
    // PRINT "===========".
    // PRINT (-360 + (50 / 100) * 720).
    // PRINT (-360 + (50 / 100) * 720).
    // PRINT (-360 + (50 / 100) * 720).

    // PRINT "SHIP:up: " + SHIP:up.
    // PRINT "SHIP:facing (direction ship is facing): " + SHIP:facing.
    // PRINT "SHIP:q: " + SHIP:q.
    // PRINT "SHIP:heading: " + SHIP:heading().
    // PRINT "SHIP:verticalspeed: " + SHIP:verticalspeed.
    // PRINT "SHIP:groundspeed: " + SHIP:groundspeed.

    // Update Loop will run until user kills the program
    update(
        rotorSvc,
        ctrlSurfaceSvc,
        engineSvc,
        uiSvc,
        terminalInputSvc,
        EVENT_BUS,
        someStateToRefactor
    ).
}

main().