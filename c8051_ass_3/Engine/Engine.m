//
//  Engine.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Engine.h"

@implementation Engine

- (id)init {
    if (self == [super init]) {
        renderer = [[Renderer alloc] init];
    }
    return self;
}

- (void)initView:(GLKView *)view {
    [renderer setView:view];
}

- (Renderer *)getRenderer {
    return renderer;
}

- (void)renderGameObject:(GameObject *)gameObject {
    for (int i = 0; i < [gameObject getMeshes].count; i++) {
        [renderer renderMesh:[[gameObject getMeshes] objectAtIndex:i] position:[gameObject getPosition] rotation:[gameObject getRotation] scale:[gameObject getScale]];
    }
}

@end
