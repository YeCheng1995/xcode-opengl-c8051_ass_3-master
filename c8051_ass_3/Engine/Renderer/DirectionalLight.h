//
//  DirectionalLight.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Light.h"

extern GLKVector3 DIRECTIONALLIGHT_MORNING;
extern GLKVector3 DIRECTIONALLIGHT_NIGHT;

@interface DirectionalLight : Light {
    GLKVector3 direction;
}
/*!
 * Returns the direction of the DirectionalLight.
 * @author Jason Chung
 *
 * @return The direction of the DirectionalLight.
 */
- (GLKVector3)getDirection;
/*!
 * Sets the direction of the DirectionalLight.
 * @author Jason Chung
 *
 * @param DIRECTION The direction of the DirectionalLight.
 */
- (void)setDirection:(GLKVector3)DIRECTION;

@end
