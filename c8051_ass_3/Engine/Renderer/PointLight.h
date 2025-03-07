//
//  PointLight.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

@interface PointLight : Light {
    // The position of the light
    GLKVector3 position;
    // Makes sure the resulting denominator never gets smaller than 1
    GLfloat constant;
    // Linear is multiplied with the distance that reduces the intensity in a linear fashion
    GLfloat linear;
    // Multiplied with the quadrant of the distance and sets a quadratic decease of intensity for the light source
    GLfloat quadratic;
}
/*!
 * Returns the position of the PointLight.
 * @author Jason Chung
 *
 * @return The position of the PointLight.
 */
- (GLKVector3)getPosition;
/*!
 * Returns the constant of the PointLight.
 * @author Jason Chung
 *
 * @return The constant of the PointLight.
 */
- (GLfloat)getConstant;
/*!
 * Returns the linear of the PointLight.
 * @author Jason Chung
 *
 * @return The linear of the PointLight.
 */
- (GLfloat)getLinear;
/*!
 * Returns the quadratic of the PointLight.
 * @author Jason Chung
 *
 * @return The quadratic of the PointLight.
 */
- (GLfloat)getQuadratic;

/*!
 * Sets the position of the PointLight.
 * @author Jason Chung
 *
 * @param POSITION The position of the PointLight.
 */
- (void)setPosition:(GLKVector3)POSITION;
/*!
 * Sets the constant of the PointLight.
 * @author Jason Chung
 *
 * @param CONSTANT The constant of the PointLight.
 */
- (void)setConstant:(GLfloat)CONSTANT;
/*!
 * Sets the linear of the PointLight.
 * @author Jason Chung
 *
 * @param LINEAR The linear of the PointLight.
 */
- (void)setLinear:(GLfloat)LINEAR;
/*!
 * Sets the quadratic of the PointLight.
 * @author Jason Chung
 *
 * @param QUADRATIC The quadratic of the PointLight.
 */
- (void)setQuadratic:(GLfloat)QUADRATIC;

@end
