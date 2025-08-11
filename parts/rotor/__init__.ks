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
    LOCAL self to LEXICON().

    // fields
    self:ADD("id", idInc).
    self:ADD("locked", rotorModuleInc:GETFIELD("lock")).
    self:ADD("module", rotorModuleInc).
    self:ADD("invertedDirection", rotorModuleInc:GETFIELD("invert direction")).
    self:ADD("desiredAngle", rotorModuleInc:GETFIELD("neutral position")).
    self:ADD("clampValue", 0).
    self:ADD("settings", RotorSettings(minEngineAngleInc, maxEngineAngleInc)).

    // functions
    self:ADD("get_target_angle", {
            LOCAL percentageAlongCurve to (
                (self:desiredAngle - self:settings:neutralRotationMin)
                / self:settings:neutralRotaDelta
            ).
            return self:settings:minEngineAngle + (self:settings:neutralRotaTrueDelta * percentageAlongCurve).
        }
    ).
    self:ADD("modulate_vtol_angle", {
        parameter 
            angleOffset,
            absoluteMode is false.

        // print rotor:GETMODULE(moduleName):suffixnames().
        // print rotor:GETMODULE(moduleName):ALLACTIONNAMES().
        // print rotorModule:ALLFIELDNAMES().
        LOCAL currentPosition to self:module:GETFIELD("neutral position").
        LOCAL invertDirection to self:module:GETFIELD("invert direction").
        
        LOCAL newPosition to min(
            max(currentPosition + angleOffset, self:settings:neutralRotationMin),
            self:settings:neutralRotationMax
        ).
        if absoluteMode { 
            SET newPosition to angleOffset.
        }

        SET self:invertedDirection to invertDirection.
        SET self:desiredAngle to newPosition.
        // update_rotor_lock_status_readout("false", rotor:id).

        self:unlock_rotor().
        self:module:SETFIELD("neutral position", newPosition).
    }).
    self:ADD("lock_rotor", {
            LOCAL isLocked to self:locked.
            if isLocked {
                return.
            }

            LOCAL currentAngle to self:module:GETFIELD("current position").
            LOCAL targetAngle to self:get_target_angle().
            LOCAL positionDelta to ABS(ABS(targetAngle) - ABS(currentAngle)).

            if positionDelta < 0.15 {
                self:module:SETFIELD("lock", true).
                SET self:locked to true.
                return true.
            }

            return false.
        }
    ).
    self:ADD("unlock_rotor", {
            LOCAL isLocked to self:locked.
            if isLocked = False {
                return.
            }

            self:module:SETFIELD("lock", false).
            SET self:locked to false.
        }
    ).

    return self.
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
            _eventBus:fire1(_eventBus, EVENT_ROTOR_ANGLE_CHANGE, _rotor).
        } else { 
            _rotor:lock_rotor().
            _eventBus:fire1(_eventBus, EVENT_ROTOR_LOCK_STATUS_CHANGE, _rotor).
        }
    }
    // if pitchInput <> 0 and AG1 { 
    //     sync_rotor_angles(rotor_map, desiredAngle).
    // }
}
