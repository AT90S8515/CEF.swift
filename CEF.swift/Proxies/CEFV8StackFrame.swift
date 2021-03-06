//
//  CEFV8StackFrame.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 08. 01..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

public extension CEFV8StackFrame {
    
    /// Returns true if the underlying handle is valid and it can be accessed on
    /// the current thread. Do not call any other methods if this method returns
    /// false.
    public var isValid: Bool {
        return cefObject.is_valid(cefObjectPtr) != 0
    }
    
    /// Returns the name of the resource script that contains the function.
    public var scriptName: String {
        let cefStrPtr = cefObject.get_script_name(cefObjectPtr)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return CEFStringToSwiftString(cefStrPtr.memory)
    }

    /// Returns the name of the resource script that contains the function or the
    /// sourceURL value if the script name is undefined and its source ends with
    /// a "//@ sourceURL=..." string.
    public var scriptNameOrSourceURL: String {
        let cefStrPtr = cefObject.get_script_name_or_source_url(cefObjectPtr)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return CEFStringToSwiftString(cefStrPtr.memory)
    }
    
    /// Returns the name of the function.
    public var functionName: String {
        let cefStrPtr = cefObject.get_function_name(cefObjectPtr)
        defer { CEFStringPtrRelease(cefStrPtr) }
        return CEFStringToSwiftString(cefStrPtr.memory)
    }

    /// Returns the 1-based line number for the function call or 0 if unknown.
    public var lineNumber: Int {
        return Int(cefObject.get_line_number(cefObjectPtr))
    }
    
    /// Returns the 1-based column offset on the line for the function call or 0 if
    /// unknown.
    public var column: Int {
        return Int(cefObject.get_column(cefObjectPtr))
    }

    /// Returns true if the function was compiled using eval().
    public var isEval: Bool {
        return cefObject.is_eval(cefObjectPtr) != 0
    }

    /// Returns true if the function was called as a constructor via "new".
    public var isConstructor: Bool {
        return cefObject.is_constructor(cefObjectPtr) != 0
    }

}

