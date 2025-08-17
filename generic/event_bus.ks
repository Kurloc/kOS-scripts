FUNCTION EventBus {
    LOCAL SELF to LEX().

    SET SELF:CASESENSITIVE to true.
    SELF:ADD("events", LEX()).
    SET SELF["events"]:CASESENSITIVE to true.
    
    FUNCTION fire {
        parameter eventName.

        for delegate in SELF:events[eventName] { 
            delegate().
        }
    }
    FUNCTION fire1 {
        parameter eventName, param1.

        for delegate in SELF:events[eventName] { 
            delegate(param1).
        }
    }
    FUNCTION fire2 {
        parameter eventName, param1, param2.
        
        for delegate in SELF:events[eventName] { 
            delegate(param1, param2).
        }
    }
    FUNCTION fire3 {
        parameter eventName, param1, param2, param3.
        
        for delegate in SELF:events[eventName] { 
            delegate(param1, param2, param3).
        }
    }
    FUNCTION fire4 {
        parameter eventName, param1, param2, param3, param4.
        
        for delegate in SELF:events[eventName] { 
            delegate(param1, param2, param3, param4).
        }
    }
    FUNCTION fire5 {
        parameter eventName, param1, param2, param3, param4, param5.
        
        for delegate in SELF:events[eventName] { 
            delegate(param1, param2, param3, param4, param5).
        }
    }
    FUNCTION fire6 {
        parameter eventName, param1, param2, param3, param4, param5, param6.
        
        for delegate in SELF:events[eventName] { 
            delegate(param1, param2, param3, param4, param5, param6).
        }
    }
    FUNCTION register {
        parameter eventName, delegate.

        if SELF:events:hasKey(eventName) = false { 
            SELF:events:Add(eventName, LIST()).
        }
        
        if delegate:typename = "List" { 
            for dele in delegate {
                SELF:events[eventName]:add(dele).
            }
        } else { 
            SELF:events[eventName]:add(delegate).
        }
    }

    SELF:ADD("fire",  fire@).
    SELF:ADD("fire1", fire1@).
    SELF:ADD("fire2", fire2@).
    SELF:ADD("fire3", fire3@).
    SELF:ADD("fire4", fire4@).
    SELF:ADD("fire5", fire5@).
    SELF:ADD("fire6", fire6@).
    SELF:ADD("register", register@).

    return SELF.
}
