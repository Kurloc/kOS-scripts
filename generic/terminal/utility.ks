GLOBAL __NEXT_COLUMN to -40.
FUNCTION NEXT_COLUMN {
    parameter elementColumnWidth to 1.
    SET __NEXT_COLUMN to __NEXT_COLUMN + elementColumnWidth.
    return __NEXT_COLUMN.
}

GLOBAL __NEXT_LAYOUT_COLUMN to 0.
FUNCTION NEXT_LAYOUT_COLUMN {
    parameter elementColumnWidth to 1.
    LOCAL returnValue to __NEXT_LAYOUT_COLUMN.
    SET __NEXT_LAYOUT_COLUMN to __NEXT_LAYOUT_COLUMN + elementColumnWidth.
    return returnValue.
}

GLOBAL __NEXT_LAYOUT_ROW to 0.
FUNCTION NEXT_LAYOUT_ROW {
    parameter elementColumnHeight to 1.
    LOCAL returnValue to __NEXT_LAYOUT_ROW.
    SET __NEXT_LAYOUT_ROW to __NEXT_LAYOUT_ROW + elementColumnHeight.
    return returnValue.
}

GLOBAL __NEXT_ROW to 1.
FUNCTION NEXT_ROW {
    parameter elementRowHeight to 1.
    SET __NEXT_ROW to __NEXT_ROW + elementRowHeight.
    return __NEXT_ROW.
}

FUNCTION KFormat {
    parameter 
        classToPullFrom,
        template
    .

    SET attributesToFetch to List().
    SET keyNameStart to -1.
    SET charBuffer to List().
    SET continueAddingChars to false.
    SET lastChar to -1.
    for i in range(0, template:length) {
        LOCAL currentChar to template[i].
        if continueAddingChars {
            if currentChar = "}" and lastChar = "}" {
                charBuffer:remove(charBuffer:length - 1).
                SET continueAddingChars to False.
                attributesToFetch:add(charBuffer:join("")).
            } else { 
                charBuffer:add(currentChar).
            }
        }
        if currentChar = "{" {
            if lastChar = "{" {
                SET continueAddingChars to True.
            }
        }
        SET lastChar to currentChar.
    }

    for attribute in attributesToFetch { 
        if classToPullFrom[attribute]:typename = "Lexicon" and classToPullFrom[attribute]:hasKey("get") { 
            SET template to template:replace("{{" + "{0}":format(attribute) + "}}", classToPullFrom[attribute]:get()).
        } else {
            SET template to template:replace("{{" + "{0}":format(attribute) + "}}", classToPullFrom[attribute]).
        }
    }
    return template.
}
// print KFormat("hello {{name}}").

FUNCTION Reactive {
    parameter elementToUpdate, autoRender is False, defaultValue is 0.
    // PRINT "creating Reactive on element with row of " + elementToUpdate:row.

    // SET SELF to Class(Reactive@, __file__).
    SET SELF_R to LEX().

    // SELF:ADD("elementToUpdate", elementToUpdate).
    SELF_R:ADD("value", defaultValue).
    SELF_R:ADD("get", {
        return SELF_R:value.
    }).
    SELF_R:ADD("set", { 
        parameter val. 
        SET SELF_R:value to val.
        if elementToUpdate:hasKey("update") { 
            elementToUpdate:update().
            if autoRender {
                elementToUpdate:render().
            }
        }
        return elementToUpdate.
    }).

    // SET SELF to Class(Reactive).

    return SELF_R.
}
