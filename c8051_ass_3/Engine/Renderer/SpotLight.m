//
//  SpotLight.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "SpotLight.h"

GLKVector3 SPOTLIGHT_ON_AMBIENT = { 0.05f, 0.05f, 0.05f};
GLKVector3 SPOTLIGHT_ON_DIFFUSE = { 0.6f, 0.6f, 0.6f };
GLKVector3 SPOTLIGHT_ON_SPECULAR = { 0.5f, 0.5f, 0.5f };
GLKVector3 SPOTLIGHT_OFF_DIFFUSE = { 0.0f, 0.0f, 0.0f };

@implementation SpotLight

- (id)initWithDirection:(GLKVector3)DIRECTION {
    if (self == [super init]) {
        name = @"spotLight";
        direction = DIRECTION;
        ambient = SPOTLIGHT_ON_AMBIENT;
        diffuse = SPOTLIGHT_ON_DIFFUSE;
        specular = SPOTLIGHT_ON_SPECULAR;
        cutOff = cosf(GLKMathDegreesToRadians(12.5f));
        outerCutOff = cosf(GLKMathDegreesToRadians(15.0f));
    }
    return self;
}

- (GLKVector3)getDirection {
    return direction;
}
    
- (GLfloat)getCutOff {
    return cutOff;
}
    
- (GLfloat)getOuterCutOff {
    return outerCutOff;
}

- (void)setDirection:(GLKVector3)DIRECTION {
    direction = DIRECTION;
}
    
- (void)setCutOff:(GLfloat)CUTOFF {
    cutOff = CUTOFF;
}
    
- (void)setOuterCutOff:(GLfloat)OUTERCUTOFF {
    outerCutOff = OUTERCUTOFF;
}

- (void)renderWithProgram:(Program *)program {
    [super renderWithProgram:program];
    
    [program set3fv:direction.v uniformName:[NSString stringWithFormat:@"%@.direction", name]];
    [program set1f:cutOff uniformName:[NSString stringWithFormat:@"%@.cutOff", name]];
    [program set1f:outerCutOff uniformName:[NSString stringWithFormat:@"%@.outerCutOff", name]];
}

@end
