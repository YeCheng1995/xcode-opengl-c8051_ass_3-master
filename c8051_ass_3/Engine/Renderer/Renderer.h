//
//  Renderer.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Program.h"
#import "Mesh.h"
#import "Camera.h"
#import "Light.h"

extern const NSString *KEY_PROGRAM_BASIC;

@interface Renderer : NSObject {
	EAGLContext *context;
    
    NSMutableDictionary<NSString *, Program *> *cachedPrograms;
    
    GLKMatrix4 viewMatrix;
    GLKMatrix4 projectionMatrix;
	
	GLfloat aspectRatio;
    Camera *mainCamera;
}

- (void)setView:(GLKView *)view;
- (Camera *)getCamera;
- (void)setCamera:(Camera *)camera;

- (void)setupRender:(CGRect)rect;
- (void)setupRender:(CGRect)rect program:(Program *)program;
- (void)clear;
- (void)renderMesh:(Mesh *)mesh position:(GLKVector3)position rotation:(GLKVector3)rotation scale:(GLKVector3)scale;
- (void)renderMesh:(Mesh *)mesh program:(Program *)program position:(GLKVector3)position rotation:(GLKVector3)rotation scale:(GLKVector3)scale;
- (void)renderLight:(Light *)light;
- (void)renderLight:(Light *)light program:(Program *)program;

- (Program *)getCachedProgram:(NSString *)key;

- (GLKMatrix4)getProjectionMatrix;

@end
