/// Structs
FUNCTION RotorSettings {
    parameter 
        minEngineAngle is -90.75,
        maxEngineAngle is 90.75
        .

    LOCAL self to LEXICON().
    LOCAL rangeOfRotationDegrees to 720.
    LOCAL minOfRange to 0 - (rangeOfRotationDegrees / 2).

    LOCAL minimumEngineRotationAngle to -90.750.
    LOCAL maxEngineRotationAngle to 90.750.

    LOCAL neutralRotationMin to ((minimumEngineRotationAngle - minOfRange) / rangeOfRotationDegrees) * 100.
    LOCAL neutralRotationMax to ((maxEngineRotationAngle - minOfRange) / rangeOfRotationDegrees) * 100.
    
    self:ADD("angleDeltaStrength", 1.0).
    self:ADD("minEngineAngle", minEngineAngle).
    self:ADD("maxEngineAngle", maxEngineAngle).
    self:ADD("neutralRotationMin", neutralRotationMin).
    self:ADD("neutralRotationMax", neutralRotationMax).
    self:ADD("neutralRotaDelta", neutralRotationMax - neutralRotationMin).
    self:ADD("neutralRotaTrueDelta", ABS(minimumEngineRotationAngle - maxEngineRotationAngle)).

    return self.
}

FUNCTION Rotor {
    parameter rotorModuleInc, idInc, minEngineAngleInc, maxEngineAngleInc.
    LOCAL SELF to LEXICON().

    // fields
    SELF:ADD("id", idInc).
    SELF:ADD("locked", rotorModuleInc:GETFIELD("lock")).
    SELF:ADD("module", rotorModuleInc).
    SELF:ADD("invertedDirection", rotorModuleInc:GETFIELD("invert direction")).
    SELF:ADD("desiredAngle", rotorModuleInc:GETFIELD("neutral position")).
    SELF:ADD("clampValue", 0).
    SELF:ADD("settings", RotorSettings(minEngineAngleInc, maxEngineAngleInc)).

    // functions
    SELF:ADD("get_target_angle", {
            LOCAL percentageAlongCurve to (
                (SELF:desiredAngle - SELF:settings:neutralRotationMin)
                / SELF:settings:neutralRotaDelta
            ).
            return SELF:settings:minEngineAngle + (SELF:settings:neutralRotaTrueDelta * percentageAlongCurve).
        }
    ).
    SELF:ADD("modulate_vtol_angle", {
        parameter 
            angleOffset,
            absoluteMode is false.

        LOCAL currentPosition to SELF:module:GETFIELD("neutral position").
        LOCAL invertDirection to SELF:module:GETFIELD("invert direction").
        
        LOCAL newPosition to min(
            max(currentPosition + angleOffset, SELF:settings:neutralRotationMin),
            SELF:settings:neutralRotationMax
        ).
        if absoluteMode { 
            SET newPosition to angleOffset.
        }

        SET SELF:invertedDirection to invertDirection.
        SET SELF:desiredAngle to newPosition.

        SELF:unlock_rotor().
        SELF:module:SETFIELD("neutral position", newPosition).
    }).
    SELF:ADD("lock_rotor", {
            LOCAL isLocked to SELF:locked.
            if isLocked {
                return.
            }

            LOCAL currentAngle to SELF:module:GETFIELD("current position").
            LOCAL targetAngle to SELF:get_target_angle().
            LOCAL positionDelta to ABS(ABS(targetAngle) - ABS(currentAngle)).

            if positionDelta < 0.15 {
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

    SELF:ADD("rotors", rotors).
    SELF:ADD("angleDeltaStrength", 1.0).
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

    FOR _rotor in rotor_map:rotors {
        if doModulation {
            _rotor:modulate_vtol_angle(desiredAngle, absoluteMode).
            _eventBus:fire1(EVENT_ROTOR_ANGLE_CHANGE, _rotor).
        } else { 
            _rotor:lock_rotor().
            _eventBus:fire1(EVENT_ROTOR_LOCK_STATUS_CHANGE, _rotor).
        }
    }

    // We probably shouldn't need this to run all the time
    // if pitchInput <> 0 and AG1 { 
    //     sync_rotor_angles(rotor_map, desiredAngle).
    // }
}
