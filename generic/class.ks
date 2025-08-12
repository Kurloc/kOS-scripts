// This was a failed experiement, unless I add some magical dunder methods for classes it not very valuable.
Function Class { 
    parameter 
        SELF,
        functions, 
        publicFields, 
        privateFields.

    for funcName in functions:keys() { 
        SELF:ADD(funcName, functions[funcName]).
    }

    for fieldName in publicFields:keys() {
        SELF:ADD(fieldName, publicFields[fieldName]).
    }

    for fieldName in privateFields:keys() {
        SELF:ADD(fieldName, privateFields[fieldName]).
    }

    return SELF.
}



FUNCTION MyNewClass {
    LOCAL SELF to LEX().

    LOCAL publicFields to LEX(
        "myValue", 0
    ).
    LOCAL functions to LEX(
        "add", {return publicFields:myValue + 1.},
        "increment", {SET publicFields:myValue to publicFields:myValue.}
    ).
    LOCAL privateFields to LEX().

    return Class(
        functions,
        publicFields,
        privateFields
    ).
}

LOCAL t to MyNewClass().
print t:add().
t:increment().
print t:add().
t:increment().
print t:add().
t:increment().
