// @Deprecating global state, it was a bad idea :D (always has been...)
GLOBAL __NEXT_COLUMN to 0.
FUNCTION NEXT_COLUMN {
    parameter elementColumnWidth to 1.
    LOCAL returnValue to __NEXT_COLUMN.
    SET __NEXT_COLUMN to __NEXT_COLUMN + elementColumnWidth.

    return returnValue.
}
FUNCTION RESET_COLUMN {
    parameter resetValue to 0.
 
    SET __NEXT_COLUMN to resetValue.
    return __NEXT_COLUMN.
}

GLOBAL __NEXT_LAYOUT_COLUMN to 0.
FUNCTION NEXT_LAYOUT_COLUMN {
    parameter elementColumnWidth to 1.
    LOCAL returnValue to __NEXT_LAYOUT_COLUMN.
    SET __NEXT_LAYOUT_COLUMN to __NEXT_LAYOUT_COLUMN + elementColumnWidth.

    return returnValue.
}
FUNCTION RESET_LAYOUT_COLUMN {
    parameter resetValue to 0.
 
    SET __NEXT_LAYOUT_COLUMN to resetValue.
    return __NEXT_LAYOUT_COLUMN.
}

GLOBAL __NEXT_LAYOUT_ROW to 5.
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

FUNCTION OffSetScope {
    SET SELF_OFFSET_SCOPE to LEX().
    SELF_OFFSET_SCOPE:ADD("__next_column", 0).
    SELF_OFFSET_SCOPE:ADD("__next_layout_column", -40).
    SELF_OFFSET_SCOPE:ADD("__next_layout_row", 0).
    SELF_OFFSET_SCOPE:ADD("__next_row", 0).

    FUNCTION NEXT_COLUMN {
        parameter elementColumnWidth to 1.
        LOCAL returnValue to SELF_OFFSET_SCOPE:__next_column.
        SET SELF_OFFSET_SCOPE:__next_column to SELF_OFFSET_SCOPE:__next_column + elementColumnWidth.

        return returnValue.
    }
    FUNCTION NEXT_LAYOUT_COLUMN {
        parameter elementColumnWidth to 1.
        LOCAL returnValue to SELF_OFFSET_SCOPE:__next_layout_column.
        SET SELF_OFFSET_SCOPE:__next_layout_column to SELF_OFFSET_SCOPE:__next_layout_column + elementColumnWidth.

        return returnValue.
    }
    FUNCTION NEXT_LAYOUT_ROW {
        parameter elementColumnHeight to 1.
        LOCAL returnValue to SELF_OFFSET_SCOPE:__next_layout_row.
        SET SELF_OFFSET_SCOPE:__next_layout_row to SELF_OFFSET_SCOPE:__next_layout_row + elementColumnHeight.

        return returnValue.
    }
    FUNCTION NEXT_ROW {
        parameter elementRowHeight to 1.
        SET SELF_OFFSET_SCOPE:__next_row to SELF_OFFSET_SCOPE:__next_row + elementRowHeight.
        return SELF_OFFSET_SCOPE:__next_row.
    }
    FUNCTION RESET_COLUMN {
        parameter resetValue to 0.
    
        SET SELF_OFFSET_SCOPE:__next_column to resetValue.
        return SELF_OFFSET_SCOPE:__next_column.
    }
    FUNCTION RESET_ROW {
        parameter resetValue to 0.
    
        SET SELF_OFFSET_SCOPE:__next_row to resetValue.
        return SELF_OFFSET_SCOPE:__next_row.
    }
    FUNCTION RESET_LAYOUT_COLUMN {
        parameter resetValue to -25.
    
        SET SELF_OFFSET_SCOPE:__next_layout_column to resetValue.
        return SELF_OFFSET_SCOPE:__next_layout_column.
    }
    FUNCTION RESET_LAYOUT_ROW {
        parameter resetValue to 0.
    
        SET SELF_OFFSET_SCOPE:__next_layout_row to resetValue.
        return SELF_OFFSET_SCOPE:__next_layout_row.
    }

    SELF_OFFSET_SCOPE:ADD("next_column", NEXT_COLUMN@).
    SELF_OFFSET_SCOPE:ADD("next_layout_column", NEXT_LAYOUT_COLUMN@).
    SELF_OFFSET_SCOPE:ADD("next_layout_row", NEXT_LAYOUT_ROW@).
    SELF_OFFSET_SCOPE:ADD("next_row", NEXT_ROW@).
    SELF_OFFSET_SCOPE:ADD("reset_column", RESET_COLUMN@).
    SELF_OFFSET_SCOPE:ADD("reset_row", RESET_ROW@).
    SELF_OFFSET_SCOPE:ADD("reset_layout_column", RESET_LAYOUT_COLUMN@).
    SELF_OFFSET_SCOPE:ADD("reset_layout_row", RESET_LAYOUT_ROW@).

    RETURN SELF_OFFSET_SCOPE.
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
            SET template to template:replace(
                "{{" + "{0}":format(attribute) + "}}",
                classToPullFrom[attribute]:get():tostring()
            ).
        } else {
            SET template to template:replace(
                "{{" + "{0}":format(attribute) + "}}", 
                classToPullFrom[attribute]:tostring()
            ).
        }
    }
    return template.
}
// print KFormat("hello {{name}}").

FUNCTION Reactive {
    parameter elementToUpdate, autoRender is False, defaultReactiveValue is "".
    // PRINT "creating Reactive on element with row of " + elementToUpdate:row.

    // SET SELF to Class(Reactive@, __file__).
    LOCAL SELF_R to LEX().

    // SELF:ADD("elementToUpdate", elementToUpdate).
    SELF_R:ADD("autoRender", autoRender).
    SELF_R:ADD("value", defaultReactiveValue).
    SELF_R:ADD("get", {
        return SELF_R:value.
    }).
    SELF_R:ADD("set", { 
        parameter val, render is SELF_R:autoRender. 
        // print "setting reactive: {0}::{1}":format(val, val:typename).
        SET SELF_R:value to val.
        if elementToUpdate:hasKey("update") { 
            elementToUpdate:update().
            if render {
                elementToUpdate:render().
            }
        }
        return elementToUpdate.
    }).

    // SET SELF to Class(Reactive).

    return SELF_R.
}

FUNCTION repeat {
    parameter chr, length.
    if length = 0 {
        return "".
    }

    LOCAL returnStringArray is LIST().
    until returnStringArray:length = length {
        returnStringArray:add(chr).
        // print "{0} = {1}":format(returnStringArray:length, length).
    }

    return returnStringArray:join("").
}