FUNCTION EngineMap {
    LOCAL SELF to LEXICON().
    LOCAL _engines to LIST().
    LIST ENGINES IN enginesIter.
    
    for part in enginesIter {
        _engines:Add(part).
    }

    SELF:ADD("engines", _engines).
    return self.
}

// clearScreen.
// LOCAL eM to EngineMap().
// PRINT eM:keys().
// print eM:engines[0]:suffixnames().

// for eng in eM:engines {
//     eng:ACTIVATE().
// }
// SET SHIP:CONTROL:PILOTMAINTHROTTLE TO .5.

// WAIT 0.5.
// WAIT 0.5.
// WAIT 0.5.
// WAIT 0.5.
// WAIT 0.5.
// print "deactivating engines".



// // PRINT "fuel flow: " + eM:engines[0]:module:GETFIELD("fuel flow").
// // PRINT "thrust: " + eM:engines[0]:module:GETFIELD("thrust").
// // PRINT "specific impulse: " + eM:engines[0]:module:GETFIELD("specific impulse").
// // PRINT "status: " + eM:engines[0]:module:GETFIELD("status").
// // PRINT "throttle: " + eM:engines[0]:module:GETFIELD("throttle").
// // PRINT "thrust limiter: " + eM:engines[0]:module:GETFIELD("thrust limiter").

// PRINT "SHIP:airspeed " + SHIP:airspeed.
// PRINT "SHIP:altitude " + SHIP:altitude.
// PRINT "SHIP:angularmomentum " + SHIP:angularmomentum.
// PRINT "SHIP:bearing " + SHIP:bearing.
// PRINT "SHIP:heading " + SHIP:heading.
// PRINT "SHIP:thrust " + SHIP:thrust.
// PRINT "SHIP:maxthrust " + SHIP:maxthrust.
// // PRINT "SHIP:maxthrustat " + SHIP:maxthrustat.
// PRINT "SHIP:verticalspeed " + SHIP:verticalspeed.
// PRINT "SHIP:groundspeed " + SHIP:groundspeed.
// PRINT "SHIP:airspeed " + SHIP:airspeed.

// for eng in eM:engines {
//     eng:shutdown().
// }
