//
//  CEFSettings.swift
//  CEF.swift
//
//  Created by Tamas Lustyik on 2015. 07. 13..
//  Copyright © 2015. Tamas Lustyik. All rights reserved.
//

import Foundation

enum CEFLogSeverity: Int {
    case Default = 0
    case Verbose
    case Info
    case Warning
    case Error
    case Disable = 99
}

enum CEFV8ContextSafetyImplementation: Int {
    case Default = 0
    case Alternate = 1
    case Disabled = -1
}

struct CEFColor {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
    var argb: UInt32 { get { return UInt32(a) << 24 | UInt32(r) << 16 | UInt32(g) << 8 | UInt32(b) } }
    
    init(argb: UInt32) {
        r = UInt8((argb >> 16) & 0xff)
        g = UInt8((argb >> 8) & 0xff)
        b = UInt8(argb & 0xff)
        a = UInt8((argb >> 24) & 0xff)
    }
}

struct CEFSettings {
    var singleProcess: Bool
    var noSandbox: Bool
    var browserSubprocessPath: String
    var multiThreadedMessageLoop: Bool
    var windowlessRenderingEnabled: Bool
    var commandLineArgsDisabled: Bool
    var cachePath: String
    var userDataPath: String
    var persistSessionCookies: Bool
    var userAgent: String
    var productVersion: String
    var locale: String
    var logFile: String
    var logSeverity: CEFLogSeverity
    var javascriptFlags: String
    var resourcesDirPath: String
    var localesDirPath: String
    var packLoadingDisabled: Bool
    var remoteDebuggingPort: Int16
    var uncaughtExceptionStackSize: Int
    var contextSafetyImplementation: CEFV8ContextSafetyImplementation
    var ignoreCertificateErrors: Bool
    var backgroundColor: CEFColor
    var acceptLanguageList: String
    
    init() {
    }
    
    func toCEF() -> cef_settings_t {
        var cefStruct = cef_settings_t()
        
        cefStruct.single_process = singleProcess ? 1 : 0
        cefStruct.no_sandbox = noSandbox ? 1 : 0
        CEFStringSetFromSwiftString(browserSubprocessPath, cefString: &cefStruct.browser_subprocess_path)
        cefStruct.multi_threaded_message_loop = multiThreadedMessageLoop ? 1 : 0
        cefStruct.windowless_rendering_enabled = windowlessRenderingEnabled ? 1 : 0
        cefStruct.command_line_args_disabled = commandLineArgsDisabled ? 1 : 0
        CEFStringSetFromSwiftString(cachePath, cefString: &cefStruct.cache_path)
        CEFStringSetFromSwiftString(userDataPath, cefString: &cefStruct.user_data_path)
        cefStruct.persist_session_cookies = persistSessionCookies ? 1 : 0
        CEFStringSetFromSwiftString(userAgent, cefString: &cefStruct.user_agent)
        CEFStringSetFromSwiftString(productVersion, cefString: &cefStruct.product_version)
        CEFStringSetFromSwiftString(locale, cefString: &cefStruct.locale)
        CEFStringSetFromSwiftString(logFile, cefString: &cefStruct.log_file)
        cefStruct.log_severity = cef_log_severity_t(rawValue: UInt32(logSeverity.rawValue))
        CEFStringSetFromSwiftString(javascriptFlags, cefString: &cefStruct.javascript_flags)
        CEFStringSetFromSwiftString(resourcesDirPath, cefString: &cefStruct.resources_dir_path)
        CEFStringSetFromSwiftString(localesDirPath, cefString: &cefStruct.locales_dir_path)
        cefStruct.pack_loading_disabled = packLoadingDisabled ? 1 : 0
        cefStruct.remote_debugging_port = Int32(remoteDebuggingPort)
        cefStruct.uncaught_exception_stack_size = Int32(uncaughtExceptionStackSize)
        cefStruct.context_safety_implementation = Int32(contextSafetyImplementation.rawValue)
        cefStruct.ignore_certificate_errors = ignoreCertificateErrors ? 1 : 0
        cefStruct.background_color = backgroundColor.argb
        CEFStringSetFromSwiftString(acceptLanguageList, cefString: &cefStruct.accept_language_list)
        
        return cefStruct
    }

}

extension cef_settings_t {
    mutating func clear() {
        cef_string_utf16_clear(&browser_subprocess_path)
        cef_string_utf16_clear(&cache_path)
        cef_string_utf16_clear(&user_data_path)
        cef_string_utf16_clear(&user_agent)
        cef_string_utf16_clear(&product_version)
        cef_string_utf16_clear(&locale)
        cef_string_utf16_clear(&log_file)
        cef_string_utf16_clear(&javascript_flags)
        cef_string_utf16_clear(&resources_dir_path)
        cef_string_utf16_clear(&locales_dir_path)
        cef_string_utf16_clear(&accept_language_list)
    }
}

