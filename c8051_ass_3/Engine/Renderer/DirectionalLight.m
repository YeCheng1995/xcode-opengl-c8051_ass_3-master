//
//  DirectionalLight.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "DirectionalLight.h"

GLKVector3 DIRECTIONALLIGHT_MORNING = { 0.3f, 0.3f, 0.3f };
GLKVector3 DIRECTIONALLIGHT_NIGHT = { 0.05f, 0.05f, 0.05f };

@implementation DirectionalLight

- (id)init {
    if (self == [super init]) {
        name = @"dirLight";
        direction = GLKVector3Make(-0.2f, -1.0f, -0.3f);
        ambient = DIRECTIONALLIGHT_MORNING;
        diffuse = GLKVector3Make(0.4f, 0.4f, 0.4f);
        specular = GLKVector3Make(0.5f, 0.5f, 0.5f);
    }
    return self;
}

- (GLKVector3)getDirection {
    return direction;
}

- (void)setDirection:(GLKVector3)DIRECTION {
    direction = DIRECTION;
}

- (void)renderWithProgram:(Program *)program {
    [super renderWithProgram:program];
    [program set3fv:direction.v uniformName:[NSString stringWithFormat:@"%@.direction", name]];
}

@end
