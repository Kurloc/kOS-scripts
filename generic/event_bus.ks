FUNCTION EventBus {
    LOCAL SELF to LEX().
    SET SELF["events"] to LEX().

    SELF:ADD("fire", {
        parameter eventName.

        for delegate in SELF:events[eventName] { 
            delegate().
        }
    }).
    SELF:ADD("fire1", {
        parameter eventName, param1.

        for delegate in SELF:events[eventName] { 
            delegate(param1).
        }
    }).
    SELF:ADD("fire2", 
        {
            parameter eventName, param1, param2.
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2).
            }
        }
    ).
    SELF:ADD("fire3", 
        {
            parameter eventName, param1, param2, param3.
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3).
            }
        }
    ).
    SELF:ADD("fire4", 
        {
            parameter eventName, param1, param2, param3, param4.
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3, param4).
            }
        }
    ).
    SELF:ADD("fire5", 
        {
            parameter eventName, param1, param2, param3, param4, param5.
            
            for delegate in SELF:events[eventName] { 
                delegate(param1, param2, param3, param4, param5).
            }
        }
    ).
    SELF:ADD("fire6", 
        {
            parameter eventName, param1, param2, param3, param4, param5, param6.
            
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
    }).

    return SELF.
}
