//
//  Camera.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

extern GLfloat DEFAULT_YAW;
extern GLfloat DEFAULT_PITCH;
extern GLfloat DEFAULT_ZOOM;
extern GLfloat DEFAULT_FOV;
extern GLfloat DEFAULT_NEAR_CLIPPING_PLANE;
extern GLfloat DEFAULT_FAR_CLIPPING_PLANE;

@interface Camera : NSObject {
    // The position
    GLKVector3 position;
    // The direction it is facing
    GLKVector3 front;
    // The up direction
    GLKVector3 up;
    // The right direction
    GLKVector3 right;
    // The world's up direction
    GLKVector3 worldUp;
    /* Euler angles */
    GLfloat yaw;
    GLfloat pitch;
    /* Camera options */
    GLfloat zoom;
	GLfloat fov;
	GLfloat nearClippingPlane;
	GLfloat farClippingPlane;
}

/*!
 * @brief Default constructor
 * @author Jason Chung
 *
 * @return An id to the created instance
 */
- (id)init;
/*!
 * @brief Constructor with vectors
 * @author Jason Chung
 *
 * @param position The position of the camera
 *
 * @return An id to the created instance
 */
- (id)initWithPosition:(GLKVector3)position;
/*!
 * @brief Constructor with vectors
 * @author Jason Chung
 *
 * @param position The position of the camera
 * @param up The up position of the camera
 *
 * @return An id to the created instance
 */
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up;
/*!
 * @brief Constructor with vectors
 * @author Jason Chung
 *
 * @param position The position of the camera
 * @param up The up position of the camera
 * @param yaw The rotation around the vertical axis
 *
 * @return An id to the created instance
 */
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw;
/*!
 * @brief Constructor with vectors
 * @author Jason Chung
 *
 * @param position The position of the camera
 * @param up The up position of the camera
 * @param yaw The rotation around the vertical axis
 * @param pitch The rotation around side-to-side axis
 *
 * @return An id to the created instance
 */
- (id)initWithPosition:(GLKVector3)position up:(GLKVector3)up yaw:(GLfloat)yaw pitch:(GLfloat)pitch;
/*!
 * @brief Constructor with vectors
 * @author Jason Chung
 *
 * @param posX The X position
 * @param posY The Y position
 * @param posZ The Z position
 * @param upX The X up direction
 * @param upY The Y up direction
 * @param upZ The Z up direction
 * @param yaw The rotation around the vertical axis
 * @param pitch The rotation around side-to-side axis
 *
 * @return An id to the created instance
 */
- (id)initWithPosition:(GLfloat)posX posY:(GLfloat)posY posZ:(GLfloat)posZ upX:(GLfloat)upX upY:(GLfloat)upY upZ:(GLfloat)upZ yaw:(GLfloat)yaw pitch:(GLfloat)pitch;
- (void)processMove:(GLfloat)movementSpeed deltaTime:(GLfloat)deltaTime;
- (void)processLook:(CGPoint)offset;
/*!
 * @brief Updates the values of the camera
 * @author Jason Chung
 */
- (void)update;
/*!
 * @brief Returns the view matrix based on current values.
 * @author Jason Chung
 *
 * @return Returns the view matrix
 */
- (GLKMatrix4)getViewMatrix;

/*!
 * Returns the position of the Camera.
 * @author Jason Chung
 *
 * @return The position of the Camera.
 */
- (GLKVector3)getPosition;
/*!
 * Returns the front vector of the Camera.
 * @author Jason Chung
 *
 * @return The front vector of the Camera.
 */
- (GLKVector3)getFront;
/*!
 * Returns the up vector of the Camera.
 * @author Jason Chung
 *
 * @return The up vector of the Camera.
 */
- (GLKVector3)getUp;
/*!
 * Returns the right vector of the Camera.
 * @author Jason Chung
 *
 * @return The right vector of the Camera.
 */
- (GLKVector3)getRight;
/*!
 * Returns the world up of the Camera.
 * @author Jason Chung
 *
 * @return The world up of the Camera.
 */
- (GLKVector3)getWorldUp;
/*!
 * Returns the yaw of the Camera.
 * @author Jason Chung
 *
 * @return The yaw of the Camera.
 */
- (GLfloat)getYaw;
/*!
 * Returns the pitch of the Camera.
 * @author Jason Chung
 *
 * @return The pitch of the Camera.
 */
- (GLfloat)getPitch;
/*!
 * Returns the zoom of the Camera.
 * @author Jason Chung
 *
 * @return The zoom of the Camera.
 */
- (GLfloat)getZoom;
/*!
 * Returns the field of view of the Camera.
 * @author Jason Chung
 *
 * @return The field of view of the Camera.
 */
- (GLfloat)getFieldOfView;
/*!
 * Returns the near clipping plane of the Camera.
 * @author Jason Chung
 *
 * @return The near clipping plane of the Camera.
 */
- (GLfloat)getNearClippingPlane;
/*!
 * Returns the far clipping plane of the Camera.
 * @author Jason Chung
 *
 * @return The far clipping plane of the Camera.
 */
- (GLfloat)getFarClippingPlane;

/*!
 * Sets the position of the Camera.
 * @author Jason Chung
 *
 * @param POSITION The new position of the Camera.
 */
- (void)setPosition:(GLKVector3)POSITION;
/*!
 * Sets the up of the Camera.
 * @author Jason Chung
 *
 * @param UP The new up of the Camera.
 */
- (void)setUp:(GLKVector3)UP;
/*!
 * Sets the yaw of the Camera.
 * @author Jason Chung
 *
 * @param YAW The new yaw of the Camera.
 */
- (void)setYaw:(GLfloat)YAW;
/*!
 * Sets the pitch of the Camera.
 * @author Jason Chung
 *
 * @param PITCH The new pitch of the Camera.
 */
- (void)setPitch:(GLfloat)PITCH;
/*!
 * Sets the zoom of the Camera.
 * @author Jason Chung
 *
 * @param ZOOM The new zoom of the Camera.
 */
- (void)setZoom:(GLfloat)ZOOM;
@end
