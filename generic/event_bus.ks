FUNCTION EventBus {
    LOCAL SELF to LEX().
    SET SELF["events"] to LEX().
    // SELF:ADD("events", LEX()).

    FUNCTION _validate_event_name { 
        parameter eventName.
        if SELF:events:keys():contains(eventName) = false {
            // print "Could not find " + eventName.
            // clearScreen.
            print "CANNOT FIND EVENT: " + eventName + " out of " + SELF:events:length + ".".
            // print SELF.
        } else { 
            print eventName + " was validated!".
        }
    }
    FUNCTION _fire1 {
        parameter zelf, eventName, param1.
        // _validate_event_name(eventName).
        // _validate_event_name(eventName).
        // _validate_event_name(eventName).
        // print SELF:keys.
        // print SELF:events.
        // print SELF:events:length.

        if zelf:events:keys():contains(eventName) {   
            for delegate in zelf:events[eventName] { 
                delegate(param1).
            }
        }
    }
    SELF:ADD("fire1", _fire1@).
    SELF:ADD("fire2", 
        {
            parameter eventName, param1, param2.
            _validate_event_name(eventName).
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2).
            }
        }
    ).
    SELF:ADD("fire3", 
        {
            parameter eventName, param1, param2, param3.
            _validate_event_name(eventName).
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3).
            }
        }
    ).
    SELF:ADD("fire4", 
        {
            parameter eventName, param1, param2, param3, param4.
            _validate_event_name(eventName).
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3, param4).
            }
        }
    ).
    SELF:ADD("fire5", 
        {
            parameter eventName, param1, param2, param3, param4, param5.
            _validate_event_name(eventName).
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3, param4, param5).
            }
        }
    ).
    SELF:ADD("fire6", 
        {
            parameter eventName, param1, param2, param3, param4, param5, param6.
            _validate_event_name(eventName).
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3, param4, param5, param6).
            }
        }
    ).
    SELF:ADD("register", {
        parameter eventName, delegate.

        if SELF:events:keys:contains(eventName) = false { 
            SELF:events:Add(eventName, LIST()).
        }
        
        if delegate:typename = "List" { 
            for dele in delegate {
                SELF:events[eventName]:add(dele).
            }
        } else { 
            SELF:events[eventName]:add(delegate).
        }
        // print "registered an event (" + eventName + ") we now have " + SELF:events:length + " events. And " + eventName + " has " + SELF:events[eventName]:length + " delegates.".
        // print eventName + SELF:events[eventName]:length.
        // print(SELF:events[eventName]).
        SET SELF["registered"] to true.
    }).

    return SELF.
}

// LOCAL test is EventBus().

// test:register("print", {
//     parameter aaa,bbb,ccc. 
//     print "hello 1.".
// }).
// test:register("print", {
//     parameter aaa,bbb,ccc. 
//     print "hello 2.".
// }).

// test:fire3("print", "a", "b", "c").