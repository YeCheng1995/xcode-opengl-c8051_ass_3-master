//
//  ShaderAttribute.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "ShaderAttribute.h"

@implementation ShaderAttribute

- (id)initWithName:(NSString *)NAME attributeId:(GLuint)ATTRIBUTEID {
    if (self == [super init]) {
        name = NAME;
        attributeId = ATTRIBUTEID;
    }
    return self;
}

- (NSString *)getName {
    return name;
}

- (GLuint)getId {
    return attributeId;
}

@end
