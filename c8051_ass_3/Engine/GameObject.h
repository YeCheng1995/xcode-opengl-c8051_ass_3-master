//
//  GameObject.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//
#import <GLKit/GLKit.h>
#import "Renderer/Mesh.h"
#import "Renderer/Program.h"
#import "BoundingBox.h"

@interface GameObject : NSObject {
    BoundingBox *boundingBox;
    
    GLKVector3 position;
    GLKVector3 rotation;
    GLKVector3 scale;
    
    NSMutableArray<Mesh *> *meshes;
}

- (BoundingBox *)getBoundingBox;
- (NSMutableArray<Mesh *> *)getMeshes;

- (GLKVector3)getPosition;
- (GLKVector3)getRotation;
- (GLKVector3)getScale;

- (void)setPosition:(GLKVector3)POSITION;
- (void)setRotation:(GLKVector3)ROTATION;
- (void)setScale:(GLKVector3)SCALE;

- (void)addMesh:(Mesh *)mesh;

- (bool)collidesWithGameObject:(GameObject *)gameObject;

@end

