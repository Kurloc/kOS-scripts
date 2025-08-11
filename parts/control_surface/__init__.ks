FUNCTION ControlSurface {
    parameter
        id,
        module,
        locked.

    LOCAL SELF to LEXICON().
    SELF:ADD("id", id).
    SELF:ADD("module", module).
    SELF:ADD("locked", locked).
    SELF:ADD("yaw_locked", locked).
    SELF:ADD("pitch_locked", locked).
    SELF:ADD("roll_locked", locked).

    FUNCTION _validate_locks { 
        parameter
            locks is list("pitch", "yaw", "roll")
            .

        if locks:TYPENAME = "String" { 
            return LIST(locks).
        }

        return locks.
    }

    LOCAL _unlock is { 
        parameter
            locks is list("pitch", "yaw", "roll")
            .

        SET locks to _validate_locks(locks).
        for item in locks { 
            LOCAL isLocked to SELF:locked.
            if isLocked <> false {
                SELF:module:SETFIELD(item, false).
                SET SELF[item + "_locked"] to false.
            }
        }
    }.
    
    LOCAL _lock is { 
        parameter
            locks is list("pitch", "yaw", "roll")
            .
        
        SET locks to _validate_locks(locks).
        _unlock(locks).
        for item in locks { 
            LOCAL isLocked to SELF["locked"].
            if isLocked <> true {
                SELF:module:SETFIELD(item, true).
                SET SELF[item + "_locked"] to true.
            }
        }

        LOCAL lockString to "".
        LOCAL lockInc is 0.
        for lock in locks { 
            if lockInc > 0 { 
                SET lockString to lockString + ", " + lock.
            } else { 
                SET lockString to lock.
            }

            SET lockInc to lockInc + 1.
        }
        SET SELF:locked to lockString.
    }.

    SELF:ADD("lock", _lock).
    SELF:ADD("unlock", _unlock).

    return SELF.
}

FUNCTION ControlSurfaceMap { 
    local inc to 0.
    LOCAL SELF to LEXICON().
    SELF:ADD("ctrlSurfaces", LIST()).

    for part in SHIP:parts {
        for module in part:modules { 
            if module = "ModuleControlSurface" { 
                SELF:ctrlSurfaces:Add(
                    ControlSurface(
                        inc,
                        part:GETMODULE("ModuleControlSurface"),
                        false
                    )
                ).
                SET inc to inc + 1.
                BREAK.
            }
        }

    }

    return SELF.
}
