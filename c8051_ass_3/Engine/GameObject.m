//
//  GameObject.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (id)init {
    if (self == [super init]) {
        boundingBox = [[BoundingBox alloc] initWithPosition:GLKVector2Make(0, 0)];
        
        meshes = [NSMutableArray array];
        
        scale = GLKVector3Make(1, 1, 1);
    }
    return self;
}

- (BoundingBox *)getBoundingBox {
    return boundingBox;
}

- (NSMutableArray<Mesh *> *)getMeshes {
    return meshes;
}

- (GLKVector3)getPosition {
    return position;
}

- (GLKVector3)getRotation {
    return rotation;
}

- (GLKVector3)getScale {
    return scale;
}

- (void)setPosition:(GLKVector3)POSITION {
    position = POSITION;
    [boundingBox setPosition:GLKVector2Make(position.x, position.z)];
}

- (void)setRotation:(GLKVector3)ROTATION {
    rotation = ROTATION;
}

- (void)setScale:(GLKVector3)SCALE {
    scale = SCALE;
    [boundingBox setSize:GLKVector2Make(scale.x, scale.z)];
}

- (void)addMesh:(Mesh *)mesh {
    [meshes addObject:mesh];
}

- (bool)collidesWithGameObject:(GameObject *)gameObject {
    if ([boundingBox intersectsWithBoundingBox:[gameObject getBoundingBox]])
        return true;
    return false;
}

@end
