//
//  Light.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

@implementation Light

- (id)init {
    if (self == [super init]) {
        name = @"Light";
    }
    return self;
}

- (GLKVector3)getAmbient {
    return ambient;
}

- (GLKVector3)getDiffuse {
    return diffuse;
}

- (GLKVector3)getSpecular {
    return specular;
}

- (void)setAmbient:(GLKVector3)AMBIENT {
    ambient = AMBIENT;
}

- (void)setDiffuse:(GLKVector3)DIFFUSE {
    diffuse = DIFFUSE;
}

- (void)setSpecular:(GLKVector3)SPECULAR {
    specular = SPECULAR;
}

- (void)renderWithProgram:(Program *)program {
    [program set3fv:ambient.v uniformName:[NSString stringWithFormat:@"%@.ambient", name]];
    [program set3fv:diffuse.v uniformName:[NSString stringWithFormat:@"%@.diffuse", name]];
    [program set3fv:specular.v uniformName:[NSString stringWithFormat:@"%@.specular", name]];
}

@end
