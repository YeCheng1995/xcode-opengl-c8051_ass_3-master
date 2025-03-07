//
//  Log.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LOG_INFO,
    LOG_WARNING,
    LOG_FATAL
} LOG_LEVEL;

@interface Log : NSObject

+ (void)l:(NSString *)message;
+ (void)w:(NSString *)message;
+ (void)f:(NSString *)message;
+ (void)log:(NSString *)message logLevel:(LOG_LEVEL)logLevel;

@end
