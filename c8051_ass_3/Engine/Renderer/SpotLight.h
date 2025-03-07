//
//  SpotLight.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "PointLight.h"

extern GLKVector3 SPOTLIGHT_ON_AMBIENT;
extern GLKVector3 SPOTLIGHT_ON_DIFFUSE;
extern GLKVector3 SPOTLIGHT_ON_SPECULAR;
extern GLKVector3 SPOTLIGHT_OFF_DIFFUSE;

@interface SpotLight : PointLight {
    GLKVector3 direction;
    GLfloat cutOff;
    GLfloat outerCutOff;
}
/*!
 * @brief Initializes the instance
 * @author Jason Chung
 *
 * @param DIRECTION The direction of the SpotLight
 *
 * @return An id to the created instance
 */
- (id)initWithDirection:(GLKVector3)DIRECTION;
/*!
 * Returns the direction of the SpotLight.
 * @author Jason Chung
 *
 * @return The direction of the SpotLight.
 */
- (GLKVector3)getDirection;
    /*!
     * Returns the cut off of the SpotLight.
     * @author Jason Chung
     *
     * @return The cut off of the SpotLight.
     */
- (GLfloat)getCutOff;
    /*!
     * Returns the outer cut off of the SpotLight.
     * @author Jason Chung
     *
     * @return The outer cut off of the SpotLight.
     */
- (GLfloat)getOuterCutOff;
/*!
 * Sets the direction of the SpotLight.
 * @author Jason Chung
 *
 * @param DIRECTION The direction of the SpotLight.
 */
- (void)setDirection:(GLKVector3)DIRECTION;
    /*!
     * Sets the cut off of the SpotLight.
     * @author Jason Chung
     *
     * @param CUTOFF The cut off of the SpotLight.
     */
- (void)setCutOff:(GLfloat)CUTOFF;
    /*!
     * Sets the direction of the SpotLight.
     * @author Jason Chung
     *
     * @param OUTERCUTOFF The outer cut off of the SpotLight.
     */
- (void)setOuterCutOff:(GLfloat)OUTERCUTOFF;

@end
