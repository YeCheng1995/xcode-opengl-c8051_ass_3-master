//
//  Shader.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface Shader : NSObject {
    // A reference to the shader for OpenGL
    GLuint shaderId;
}

/*!
 * @brief Initializes and compiles the shader.
 * @author Jason Chung
 *
 * @param filename The filename of the shader
 * @param shaderType The type of shader (GL_VERTEX_SHADER, GL_FRAGMENT_SHADER, ...)
 *
 * @return An id to the created instance
 */
- (id)initWithFilename:(NSString *)filename shaderType:(GLenum)shaderType;

/*!
 * Returns the id of the Shader.
 * @author Jason Chung
 *
 * @return The id of the Shader.
 */
- (GLuint)getId;

@end
