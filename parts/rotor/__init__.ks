RUN "0:/programs/osprey/environment.ks".

/// Structs
FUNCTION RotorSettings {
    parameter 
        minAngle is ROTOR_MIN_ANGLE,
        maxAngle is ROTOR_MAX_ANGLE
        .

    LOCAL self to LEXICON().

    self:ADD("angleDeltaStrength", 0.125).
    self:ADD("minAngle", minAngle).
    self:ADD("maxAngle", maxAngle).

    return self.
}

FUNCTION Rotor {
    parameter rotorModuleInc, idInc, minAngleInc, maxAngleInc.
    LOCAL SELF to LEXICON().

    // fields
    SELF:ADD("id", idInc).
    SELF:ADD("locked", rotorModuleInc:GETFIELD("lock")).
    SELF:ADD("module", rotorModuleInc).
    SELF:ADD("desiredAngle", rotorModuleInc:GETFIELD("current position")).
    SELF:ADD("clampValue", 0).
    SELF:ADD("settings", RotorSettings(minAngleInc, maxAngleInc)).

    // functions
    SELF:ADD("modulate_vtol_angle", {
        parameter 
            angleOffset,
            absoluteMode is false.

        LOCAL currentPosition to SELF:module:GETFIELD("current position").
        
        LOCAL newAngle to min(
            max(currentPosition + angleOffset, SELF:settings:minAngle),
            SELF:settings:maxAngle
        ).
        SET newAngle to currentPosition + angleOffset.
        if absoluteMode { 
            SET newAngle to angleOffset.
        }

        SET SELF:desiredAngle to newAngle.

        SELF:unlock_rotor().
        SELF:module:SETFIELD("target position", newAngle).
        
        return newAngle.
    }).
    SELF:ADD("lock_rotor", {
            LOCAL isLocked to SELF:locked.
            if isLocked {
                return false.
            }

            LOCAL currentAngle to SELF:module:GETFIELD("current position").
            LOCAL positionDelta to ABS(ABS(SELF:desiredAngle) - ABS(currentAngle)).

            if positionDelta < 0.00375 {
                SELF:module:SETFIELD("lock", true).
                SET SELF:locked to true.
                return true.
            }

            return false.
        }
    ).
    SELF:ADD("unlock_rotor", {
            LOCAL isLocked to SELF:locked.
            if isLocked = False {
                return.
            }

            SELF:module:SETFIELD("lock", false).
            SET SELF:locked to false.
        }
    ).

    return SELF.
}

FUNCTION ShipRotorMap {
    local rotorNumber to 0.
    local self to LEXICON().
    LOCAL rotors to LIST().

    FOR r in SHIP:PARTSNAMED("IR.Rotatron.Basic.V3") {
        rotors:ADD(
            Rotor(
                r:GETMODULE("ModuleIRServo_v3"),
                rotorNumber,
                -90.75,
                90.75
            )
        ).
        SET rotorNumber to rotorNumber + 1.
    }

    SELF:ADD("rotors",             rotors).
    SELF:ADD("angleDeltaStrength", .125).
    SELF:ADD("controlsLocked",     ROTOR_CONTROLS_START_LOCKED).

    return self.
}


/// Functions
FUNCTION sync_rotor_angles { 
    parameter rotorMap, desiredAngle.

    for _rotor in rotorMap:rotors {
        _rotor:modulate_vtol_angle(desiredAngle, true).
    }
}

FUNCTION set_rotors_angles {
    parameter 
        rotor_map,
        desiredAngle, 
        _eventBus,
        absoluteMode is false, 
        doModulation is true
    .

    LOCAL i to 0.
    FOR _rotor in rotor_map:rotors {
        if doModulation {
            // Keep rotor angles in sync by modulation the lead rotor and applying the same angle to the others
            if i = 0 { 
                SET desiredAngle to _rotor:modulate_vtol_angle(desiredAngle, absoluteMode).
            } else { 
                _rotor:modulate_vtol_angle(desiredAngle, true).
            }
            _eventBus:fire1(EVENT_ROTOR_ANGLE_CHANGE, _rotor).
        } else { 
            if _rotor:lock_rotor() { 
                _eventBus:fire1(EVENT_ROTOR_LOCK_STATUS_CHANGE, _rotor).
            }
        }
        SET i to i + 1.
    }
}
