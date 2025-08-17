LOCAL __file__ to "0:/generic/class.ks".

FUNCTION Class {
    parameter 
        type,
        filePath
        .

    // print type:suffixnames.
    // print type.
    // LOCAL typeString to type:toString().
    // LOCAL nameIndex to typeString:indexof("Name=") + 5.

    // this only works for builtin types,
    // need to sniff source code and do some magic for user defined types
    // will add it when I need it though.
    // LOCAL nameEndIndex to typeString:subString(nameIndex, typeString:length - nameIndex):indexof(",").
    // LOCAL innerName to typeString:subString(nameIndex, nameEndIndex).

    // print type:name.
    // print type:TYPENAME:suffixnames.

    SET SELF to LEX().

    
    SELF:ADD("__file__", filePath).
    // SELF:ADD("__name__", innerName).
    // SELF:ADD("__type__", innerName).

    return SELF.
}

FUNCTION SubClass {
    parameter 
        type,
        baseClass
        .
 
    // can we accept the delegate of the function type to do magic?
    SET SELF to Class(baseClass).
    
    SET SELF["__name__"] to "{0}[{1}]":format(type, baseClass).
    SELF:ADD("__type__", type).
}

FUNCTION Reactive {
    parameter elementToUpdate, defaultValue is 0.

    SET SELF to Class(Reactive@, __file__).

    SELF:ADD("elementToUpdate", elementToUpdate).
    SELF:ADD("value", defaultValue).
    SELF:ADD("get", {
        return SELF:value.
    }).
    SELF:ADD("set", { 
        parameter val. 
        SET SELF:value to val.
        if elementToUpdate:hasKey("update") { 
            print "could call update here.".
            // elementToUpdate:update().
        }
    }).

    // SET SELF to Class(Reactive).

    return SELF.
}

FUNCTION test {
    print Reactive@.
    return 1 + 1.
}

FUNCTION sniff_source_code_for_types { 
    SET ppp to Path(__file__).
    CD(ppp:parent).
    LIST FILES IN filesIter.
    SET functionMap to LIST().
    // print filesIter[3]:readall():suffixnames.
    for f in filesIter { 
        if f = ppp:name {
            LOCAL fileContents to f:readall().
            print fileContents.
            LOCAL i to 0.
            for l in f:readall() {
                if l:length > 7 and l:subString(0, 8) = "FUNCTION" {
                    functionMap:add(LEX("start", i, "functionName", l:toString())).
                }
                if i > 122 {
                    print l.
                }
                SET i to i + 1.
            }
            print "FOund {0} lines":format(i:tostring).
            test().
            print functionMap.
            print (123 - 25) / 7.
        }
    }
    print Class@:inheritance.
    print Class@:hassuffix("name").
    print Class@:typename.
    print Class@:suffixnames.
}
// print SubClass@.
// print Reactive@.
// print test@.

// // RUNPATH("0:/generic/class.ks").