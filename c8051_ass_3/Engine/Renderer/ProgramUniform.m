//
//  ProgramUniform.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "ProgramUniform.h"

@implementation ProgramUniform

- (id)initWithName:(NSString *)NAME uniformId:(GLuint)UNIFORMID {
    if (self == [super init]) {
        name = NAME;
        uniformId = UNIFORMID;
    }
    return self;
}

- (NSString *)getName {
    return name;
}

- (GLuint)getId {
    return uniformId;
}

@end
