//
//  Light.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Program.h"

@interface Light : NSObject {
    GLKVector3 ambient;
    GLKVector3 diffuse;
    GLKVector3 specular;
    
    NSString *name;
}


/*!
 * @brief Initializes the instance
 * @author Jason Chung
 *
 * @return An id to the created instance
 */
- (id)init;
/*!
 * @brief Sets uniform values for the program to render
 * @author Jason Chung
 *
 * @param program The corresponding GL program
 */
- (void)renderWithProgram:(Program *)program;

- (GLKVector3)getAmbient;
- (GLKVector3)getDiffuse;
- (GLKVector3)getSpecular;

- (void)setAmbient:(GLKVector3)AMBIENT;
- (void)setDiffuse:(GLKVector3)DIFFUSE;
- (void)setSpecular:(GLKVector3)SPECULAR;

@end
