//
//  Log.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Log.h"

@implementation Log

+ (void)l:(NSString *)message {
    [Log log:message logLevel:LOG_INFO];
}

+ (void)w:(NSString *)message {
    [Log log:message logLevel:LOG_WARNING];
}

+ (void)f:(NSString *)message {
    [Log log:message logLevel:LOG_FATAL];
}

+ (void)log:(NSString *)message logLevel:(LOG_LEVEL)logLevel {
    switch (logLevel) {
        case LOG_INFO:
            NSLog(@"[%s] %@", "INFO", message);
            break;
        case LOG_WARNING:
            NSLog(@"[%s] %@", "WARNING", message);
            break;
        case LOG_FATAL:
            NSLog(@"[%s] %@", "FATAL", message);
            break;
    }
}

@end
