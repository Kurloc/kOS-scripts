RUN "0:/programs/osprey/constants.ks".

// An Object that implements OnUpdate
// 
// This service is reponsible for running in the physics update loop 
// and taking input to control a vessels rotors.
FUNCTION SynchronizedRotorSerivce {
    parameter rotorMap, mainRotor, actionGroupCache, eventBus.

    LOCAL SELF to LEX().
    SELF:ADD("rotorMap", rotorMap).
    SELF:ADD("mainRotor", mainRotor).
    SELF:ADD("eventBus", eventBus).
    SELF:ADD("actionGroupCache", actionGroupCache).

    LOCAL _handle_angle_sensitivity_changes is {
        LOCAL offset to 0.
        if SELF:actionGroupCache:ag9 <> AG9 {
            SET offset to -.25.
            SET SELF:actionGroupCache:ag9 to AG9.
            
        }
        if SELF:actionGroupCache:ag10 <> AG10 {
            SET offset to .25.
            SET SELF:actionGroupCache:ag10 to AG10.
        }
        if offset <> 0 {
            SET SELF:rotorMap:angleDeltaStrength to max(min(SELF:rotorMap:angleDeltaStrength + offset, 1.0), .25).
            SELF:eventBus:fire1(
                EVENT_ROTOR_ANGLE_DELTA_STRENGTH_CHANGE,
                (SELF:rotorMap:angleDeltaStrength * 100)
            ).
        }
    }.

    LOCAL _handle_takeoff_mode is { 
        if SELF:actionGroupCache:ag4 <> AG4 { 
            set_rotors_angles(SELF:rotorMap, 38, SELF:eventBus, true, true).
            SET SELF:actionGroupCache:ag4 to AG4.
        }
    }.

    LOCAL _handle_vtol_mode is { 
        if SELF:actionGroupCache:ag5 <> AG5 { 
            set_rotors_angles(SELF:rotorMap, 50.5, SELF:eventBus, true, true).
            SET SELF:actionGroupCache:ag5 to AG5.
        }
    }.

    LOCAL _on_update is { 
        parameter pitchInput, physicsTick.
        local lockCheckTick to MOD(physicsTick, 5).

        _handle_angle_sensitivity_changes().
        _handle_takeoff_mode().
        _handle_vtol_mode().

        if SELF:actionGroupCache:ag1 <> AG1 {
           SET SELF:actionGroupCache:ag1 to AG1.
           SELF:eventBus:fire1(
                EVENT_VTOL_CONTROLS_ENABLED_CHANGE,
                (AG1 = false):tostring()
           ).
        }

        if pitchInput <> 0 and lockCheckTick <> 0 {
            return.
        }

        set_rotors_angles(
            rotorMap,
            pitchInput * rotorMap:angleDeltaStrength,
            SELF:eventBus,
            false,
            pitchInput <> 0 and AG1
        ).
    }.

    SELF:ADD("on_update", _on_update).

    return SELF.
}
