//
//  Camera.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Camera.h"

GLfloat DEFAULT_YAW = 90.0f;
GLfloat DEFAULT_PITCH = 0.0f;
GLfloat DEFAULT_ZOOM = 45.0f;
GLfloat DEFAULT_FOV = 65.0f;
GLfloat DEFAULT_NEAR_CLIPPING_PLANE = 0.1f;
GLfloat DEFAULT_FAR_CLIPPING_PLANE = 100.0f;

@implementation Camera


- (id)init {
    return [self initWithPosition:GLKVector3Make(0.0f, 0.0f, 0.0f) up:GLKVector3Make(0.0f, 1.0f, 0.0f) yaw:DEFAULT_YAW pitch:DEFAULT_PITCH];
}

- (id)initWithPosition:(GLKVector3)POSITION {
    return [self initWithPosition:POSITION up:GLKVector3Make(0.0f, 1.0f, 0.0f) yaw:DEFAULT_YAW pitch:DEFAULT_PITCH];
}

- (id)initWithPosition:(GLKVector3)POSITION up:(GLKVector3)UP {
    return [self initWithPosition:POSITION up:UP yaw:DEFAULT_YAW pitch:DEFAULT_PITCH];
}

- (id)initWithPosition:(GLKVector3)POSITION up:(GLKVector3)UP yaw:(GLfloat)YAW {
    return [self initWithPosition:POSITION up:UP yaw:YAW pitch:DEFAULT_PITCH];
}

- (id)initWithPosition:(GLKVector3)POSITION up:(GLKVector3)UP yaw:(GLfloat)YAW pitch:(GLfloat)pitch {
    return [self initWithPosition:POSITION.x posY:POSITION.y posZ:POSITION.z upX:UP.x upY:UP.y upZ:UP.z yaw:YAW pitch:pitch];
}

- (id)initWithPosition:(GLfloat)posX posY:(GLfloat)posY posZ:(GLfloat)posZ upX:(GLfloat)upX upY:(GLfloat)upY upZ:(GLfloat)upZ yaw:(GLfloat)YAW pitch:(GLfloat)PITCH {
    if (self == [super init]) {
        position = GLKVector3Make(posX, posY, posZ);
        up = GLKVector3Make(upX, upY, upZ);
        worldUp = up;
        yaw = YAW;
        pitch = PITCH;
        zoom = DEFAULT_ZOOM;
		fov = DEFAULT_FOV;
		nearClippingPlane = DEFAULT_NEAR_CLIPPING_PLANE;
		farClippingPlane = DEFAULT_FAR_CLIPPING_PLANE;
        
        [self update];
    }
    return self;
}

- (void)processMove:(GLfloat)movementSpeed deltaTime:(GLfloat)deltaTime {
    float velocity = movementSpeed * deltaTime;
    
    position = GLKVector3Subtract(position, GLKVector3MultiplyScalar(front, velocity));
}

- (void)processLook:(CGPoint)offset {
    yaw += offset.x;
    
    [self update];
}

- (void)update {
    // Calculate the new Front vector
    front.x = cosf(GLKMathDegreesToRadians(yaw)) * cosf(GLKMathDegreesToRadians(pitch));
    front.y = sinf(GLKMathDegreesToRadians(pitch));
    front.z = sinf(GLKMathDegreesToRadians(yaw)) * cosf(GLKMathDegreesToRadians(pitch));
    front = GLKVector3Normalize(front);
    // Also re-calculate the Right and Up vector
    // normalize their vectors, because their length gets closer to 0 the more you look up or down which results in slower movement
    right = GLKVector3Normalize(GLKVector3CrossProduct(front, worldUp));
    up = GLKVector3Normalize(GLKVector3CrossProduct(right, front));
}

- (GLKMatrix4)getViewMatrix {
    return GLKMatrix4MakeLookAt(position.x, position.y, position.z, position.x + front.x, position.y + front.y, position.z + front.z, up.x, up.y, up.z);
}


- (GLKVector3)getPosition {
	return position;
}

- (GLKVector3)getFront {
	return front;
}

- (GLKVector3)getUp {
	return up;
}

- (GLKVector3)getRight {
	return right;
}

- (GLKVector3)getWorldUp {
	return worldUp;
}

- (GLfloat)getYaw {
	return yaw;
}

- (GLfloat)getPitch {
	return pitch;
}

- (GLfloat)getZoom {
	return zoom;
}

- (GLfloat)getFieldOfView {
	return fov;
}

- (GLfloat)getNearClippingPlane {
	return nearClippingPlane;
}

- (GLfloat)getFarClippingPlane {
	return farClippingPlane;
}

- (void)setPosition:(GLKVector3)POSITION {
	position = POSITION;
}

- (void)setUp:(GLKVector3)UP {
	up = UP;
}

- (void)setYaw:(GLfloat)YAW {
	yaw = YAW;
    [self update];
}

- (void)setPitch:(GLfloat)PITCH {
	pitch = PITCH;
    [self update];
}

- (void)setZoom:(GLfloat)ZOOM {
	zoom = ZOOM;
}

@end
