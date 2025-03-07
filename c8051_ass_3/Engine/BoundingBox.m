//
//  BoundingBox.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "BoundingBox.h"

@implementation BoundingBox

- (id)initWithPosition:(GLKVector2)POSITION {
    return [self initWithPosition:position size:GLKVector2Make(1, 1)];
}
- (id)initWithPosition:(GLKVector2)POSITION size:(GLKVector2)SIZE {
    if (self == [super init]) {
        position = GLKVector2AddScalar(POSITION, 0.5f);
        size = SIZE;
        enabled = GL_TRUE;
    }
    return self;
}

- (bool)intersectsWithBoundingBox:(BoundingBox *)boundingBox {
    if (!enabled) return false;
    if (![boundingBox getEnabled]) return false;
    if (
        position.x < ([boundingBox getPosition].x + [boundingBox getSize].x) &&
        (position.x + size.x) > [boundingBox getPosition].x &&
        position.y < ([boundingBox getPosition].y + [boundingBox getSize].y) &&
        (position.y + size.y) > [boundingBox getPosition].y
        ) {
        return true;
    }
    return false;
}

- (GLKVector2)getPosition {
    return position;
}

- (GLKVector2)getSize {
    return size;
}

- (GLboolean)getEnabled {
    return enabled;
}

- (void)setPosition:(GLKVector2)POSITION {
    position = POSITION;
}

- (void)setSize:(GLKVector2)SIZE {
    size = SIZE;
}

- (void)setEnabled:(GLboolean)ENABLED {
    enabled = ENABLED;
}

@end
