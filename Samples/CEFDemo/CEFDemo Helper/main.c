//
//  main.c
//  CEFDemo Helper
//
//  Created by Tamas Lustyik on 2017. 11. 12..
//  Copyright © 2017. Tamas Lustyik. All rights reserved.
//

#include "include/capi/cef_app_capi.h"
#include "include/wrapper/cef_library_loader.h"
#include "include/cef_sandbox_mac.h"
#include <libgen.h>
#include <stdio.h>

// Entry point function for sub-processes.
int main(int argc, char* argv[]) {
    // Initialize the macOS sandbox for this helper process.
    void* sandboxContext = cef_sandbox_initialize(argc, argv);
    if (!sandboxContext) {
        return 1;
    }
    
    // Load the CEF framework library at runtime instead of linking directly
    // as required by the macOS sandbox implementation.
    char fwPath[1024];
    snprintf(fwPath, 1024, "%s/../../../Chromium Embedded Framework.framework/Chromium Embedded Framework", dirname(argv[0]));
    
    if (!cef_load_library(fwPath)) {
        cef_sandbox_destroy(sandboxContext);
        return 1;
    }
    
    // Provide CEF with command-line arguments.
    cef_main_args_t mainArgs = {.argc = argc, .argv = argv};
    
    // Execute the sub-process.
    int retval = cef_execute_process(&mainArgs, NULL, NULL);
    
    cef_unload_library();
    cef_sandbox_destroy(sandboxContext);
    
    return retval;
}
