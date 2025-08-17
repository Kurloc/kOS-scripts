RUN "0:/programs/osprey/constants.ks".
RUN "0:/programs/osprey/environment.ks".

// An Object that implements OnUpdate
// 
// This service is reponsible for running in the physics update loop 
// and taking input to control a vessels rotors.
FUNCTION SynchronizedRotorSerivce {
    parameter rotorMap, mainRotor, actionGroupCache, eventBus.

    LOCAL SELF to LEX().
    SELF:ADD("rotorMap",         rotorMap).
    SELF:ADD("mainRotor",        mainRotor).
    SELF:ADD("eventBus",         eventBus).
    SELF:ADD("actionGroupCache", actionGroupCache).
    
    for r in SELF:rotorMap:rotors { 
        r:module:SETFIELD("force",        DEFAULT_ROTOR_FORCE).
        r:module:SETFIELD("acceleration", DEFAULT_ROTOR_ACCELERATION).
        r:module:SETFIELD("max speed",    DEFAULT_ROTOR_MAX_SPEED).
    }

    FUNCTION handle_angle_sensitivity_changes {
        parameter offset to 0.
        // if SELF:actionGroupCache:ag6 <> AG6 {
        //     print SELF:rotorMap:rotors[0]:module:GETFIELD("current position").
        //     print SELF:rotorMap:rotors[0]:module:GETFIELD("neutral position").
        //     SET SELF:actionGroupCache:ag6 to AG6.  
        // }
        if offset <> 0 
        {
            SET SELF:rotorMap:angleDeltaStrength to max(
                min(
                        SELF:rotorMap:angleDeltaStrength + offset,
                        1
                ),
                DEFAULT_ROTOR_ANGLE_CHANGE_INCREMENT
            ).

            SELF:eventBus:fire1(
                EVENT_ROTOR_ANGLE_DELTA_STRENGTH_CHANGE,
                (SELF:rotorMap:angleDeltaStrength * 100)
            ).
        }
    }.

    FUNCTION toggle_vtol_controls { 
        SET SELF:rotorMap:controlsLocked to not SELF:rotorMap:controlsLocked.
        SELF:eventBus:fire1(
            EVENT_VTOL_CONTROLS_ENABLED_CHANGE,
            SELF:rotorMap:controlsLocked
        ).
    }

    FUNCTION handle_takeoff_mode { 
        set_rotors_angles(SELF:rotorMap, -90, SELF:eventBus, true, true).
    }.

    FUNCTION handle_vtol_mode {
        set_rotors_angles(SELF:rotorMap, 0, SELF:eventBus, true, true).
    }.

    LOCAL _on_update is { 
        parameter pitchInput, physicsTick.
        local lockCheckTick to MOD(physicsTick, ROTOR_LOCK_CHECK_TICK_RATE) <> 0.

        if pitchInput = 0 and lockCheckTick {
            print "SKIPPING FRAME {0} : {1}":format(physicsTick, pitchInput) at (0, 45).
            return.
        }

        set_rotors_angles(
            rotorMap,
            pitchInput * rotorMap:angleDeltaStrength,
            SELF:eventBus,
            false,
            pitchInput <> 0 and SELF:rotorMap:controlsLocked
        ).
    }.

    SELF:ADD("onUpdate", _on_update).
    SELF:ADD("handle_angle_sensitivity_changes", handle_angle_sensitivity_changes@).
    SELF:ADD("handle_vtol_mode",                 handle_vtol_mode@).
    SELF:ADD("handle_takeoff_mode",              handle_takeoff_mode@).
    SELF:ADD("toggle_vtol_controls",             toggle_vtol_controls@).

    return SELF.
}
