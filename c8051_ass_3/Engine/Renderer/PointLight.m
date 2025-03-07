//
//  PointLight.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "PointLight.h"

@implementation PointLight

-  (id)init {
    if (self == [super init]) {
		name = @"pointLight";
        position = GLKVector3Make(0.0f, 0.0f, 0.0f);
        ambient = GLKVector3Make(0.05f, 0.05f, 0.05f);
        diffuse = GLKVector3Make(0.8f, 0.8f, 0.8f);
        specular = GLKVector3Make(1.0f, 1.0f, 1.0f);
        constant = 1.0f;
        linear = 0.09f;
        quadratic = 0.032f;
    }
    return self;
}

- (void)renderWithProgram:(Program *)program {
	[super renderWithProgram:program];
	
    [program set3fv:position.v uniformName:[NSString stringWithFormat:@"%@.position", name]];
    [program set1f:constant uniformName:[NSString stringWithFormat:@"%@.constant", name]];
    [program set1f:linear uniformName:[NSString stringWithFormat:@"%@.linear", name]];
    [program set1f:quadratic uniformName:[NSString stringWithFormat:@"%@.quadratic", name]];
}

- (GLKVector3)getPosition {
	return position;
}

- (GLfloat)getConstant {
	return constant;
}

- (GLfloat)getLinear {
	return linear;
}

- (GLfloat)getQuadratic {
	return quadratic;
}

- (void)setPosition:(GLKVector3)POSITION {
	position = POSITION;
}

- (void)setConstant:(GLfloat)CONSTANT {
	constant = CONSTANT;
}

- (void)setLinear:(GLfloat)LINEAR {
	linear = LINEAR;
}

- (void)setQuadratic:(GLfloat)QUADRATIC {
	quadratic = QUADRATIC;
}

@end
