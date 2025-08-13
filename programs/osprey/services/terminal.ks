RUN "0:/programs/osprey/constants.ks".
LOCAL START to TIME:seconds.

FUNCTION _setup_readout {
    parameter data.

    // rotor settings are shared for this program so we just use the first rotor for stuffz
    LOCAL mainRotor to data:rotorMap:rotors[0].

    SET TERMINAL:WIDTH TO 120.
    SET TERMINAL:height TO 50.
    Print "[INFO] Running VTOL controls in synchronous engine mode.".
    PRINT "[INFO] VTOL Handler boot was completed in {0} seconds":format(
        (TIME:seconds - START):tostring():substring(0, 5)
    ).
    PRINT UI_HEADER_FPS_ROW.
    PRINT "|Engine Angles:                             |".
    FOR _rotor in data:rotorMap:rotors {
        LOCAL angleStr to _rotor:get_target_angle():tostring().
        PRINT "|rotor #" + _rotor:id + ":     {0}°                     |":format(angleStr:substring(0, min(5, angleStr:length)):padleft(7)).
    }

    print UI_FILLER_ROW.
    print "|Rotors Lock Status:                        |".
    FOR _rotor in data:rotorMap:rotors {
        PRINT "|rotor #" + _rotor:id + ":     " + 
            _rotor:module:GETFIELD("LOCK"):tostring():padleft(24) + 
            "     |".
    }

    print UI_FILLER_ROW.
    print "|VTOL CTRLS Locked:               " + (AG1 = false):tostring():padleft(5) + "     |".
    print "|Ctrl Surfaces Locked:            " + AG2:tostring():padleft(5) + "     |".
    print UI_FILLER_ROW.
    print "|Info:                                      |".
    print "|Rotor Delta Angle Strgth: " + data:rotorAngleStrengthProgressBar:progressBarString + " |".
    print "|Rotor Min Angle: " + mainRotor:settings:minEngineAngle + "°                   |".
    print "|Rotor Max Angle: " + mainRotor:settings:maxEngineAngle + "°                    |".

    print UI_FILLER_ROW.
    print "|Engine Thrust:":padright(44) + "|".
    for i in range(0, data:engineMap:engines:length) { 
        print "|Engine #{0}: ":format(i):padright(40) + "{0} |":format(CHOOSE "ON" if data:engineMap:engines[i]:ignition else "OFF"):padleft(5).
    }

    PRINT UI_HEADER_ROW. 
    PRINT "CONTROLS:".
    PRINT "1)  TOGGLE VTOL CONTROL".
    PRINT "    - W/S for control the angle of the engines".
    PRINT "2)  LOCK CTRL SURFACES".
    PRINT "3)  UNLOCK CTRL SURFACES".
    PRINT "4)  Orient for runway take off".
    PRINT "5)  Orient for VTOL take off".
    PRINT "9)  Lower Angle Sensitivity by 25%".
    PRINT "10) Raise Angle Sensitivity by 25%".
}.

FUNCTION _update_ctrl_surfaces_lock_status_readout {
    parameter lockStatus.
    PRINT (lockStatus:tostring():padleft(16)) AT (23,(NUMBER_OF_ROTORS:value * 2) + HEADER_OFFSET + 4).
}

FUNCTION _update_rotor_angle_delta_strength_readout {
    parameter strengthPercent.
    PRINT (strengthPercent:tostring():padleft(5) + "%") AT (25,(NUMBER_OF_ROTORS:value * 2 ) + HEADER_OFFSET + 6).
}

FUNCTION _update_vtol_ctrls_readout {
    parameter lockStatus.
    PRINT (lockStatus:tostring():padleft(19)) AT (20,(NUMBER_OF_ROTORS:value * 2)+ HEADER_OFFSET + 3).
}

FUNCTION _update_rotor_angle_readout {
    parameter _rotor.

    LOCAL targetAngleStr to _rotor:get_target_angle():tostring().
    LOCAL strLength to targetAngleStr:length().
    PRINT (targetAngleStr:substring(0, min(6, strLength)):padleft(7)) AT (15,_rotor:id + HEADER_OFFSET).
}

FUNCTION _update_rotor_lock_status_readout {
    parameter _rotor.
    PRINT (_rotor:locked:tostring():padleft(24)) AT (16, (NUMBER_OF_ROTORS:value * 2) + HEADER_OFFSET + _rotor:id).
}

FUNCTION _update_engine_ignition_readout { 
    parameter engineId.

    FUNCTION _inner { 
        parameter ignition.
        PRINT "{0} |":format(
            CHOOSE "ON" 
            if ignition 
            else "OFF"
        ):padleft(5) at (
            40,
            (NUMBER_OF_ROTORS:value * 2 ) + HEADER_OFFSET + 12 + engineId
        ).
    }

    return _inner@.
}

FUNCTION _update_fps_readout { 
    parameter fps.
    PRINT "FPS: {0}":format(fps):padleft(7) AT (36, 3).
}

FUNCTION ConsoleUITemplate {
    parameter
        data,
        delegate
        .

    LOCAL SELF to LEX().
    SELF:ADD("data", data).
    SELF:ADD("render", {
        return delegate:call(SELF:data).
    }).

    return SELF.
}

FUNCTION TerminalService {
    parameter uiTemplate, eventBus.

    LOCAL SELF to LEX().

    SELF:ADD("eventBus", eventBus).
    SELF:ADD("uiTemplate", uiTemplate).
    SELF:ADD(
        "initApp", 
        {
            SELF:uiTemplate:render().

            return SELF.
        }
    ).

    return SELF.
}