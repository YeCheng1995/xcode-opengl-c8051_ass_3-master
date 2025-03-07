//
//  Program.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Program.h"
#import "../Log.h"
#import <OpenGLES/ES2/glext.h>

@implementation Program

/*!
 * @brief Prints the current info log for the program
 */
- (void)printInfoLog {
    GLsizei logLen = 0;
    GLsizei charsWritten = 0;
    GLchar *message;
    
    glGetProgramiv(programId, GL_INFO_LOG_LENGTH, &logLen);
    
    if (logLen > 0) {
        message = (GLchar *)malloc(logLen);
        glGetProgramInfoLog(programId, logLen, &charsWritten, message);
        [Log f:[NSString stringWithUTF8String:message]];
        free(message);
    }
}

- (id)initWithShaders:(NSMutableArray<Shader *> **)shaders attributes:(NSMutableArray<ShaderAttribute *> **)attributes {
    if (self == [super init]) {
        programId = glCreateProgram();
        for (Shader *shader in *shaders) {
            glAttachShader(programId, [shader getId]);
        }
        for (ShaderAttribute *attribute in *attributes) {
            glBindAttribLocation(programId, [attribute getId], [attribute getName].UTF8String);
        }
        [self compile];
        for (Shader *shader in *shaders) {
            glDetachShader(programId, [shader getId]);
            glDeleteShader([shader getId]);
        }
        uniforms = [[NSMutableArray<ProgramUniform *> alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (programId) {
        glDeleteProgram(programId);
    }
}

/*!
 * @brief Compiles the program
 */
- (void)compile {
    GLsizei success;
    
    glLinkProgram(programId);
    
    glGetProgramiv(programId, GL_LINK_STATUS, &success);
    
    if (!success) {
        [self printInfoLog];
    }
}

- (void)bind {
    glUseProgram(programId);
}

- (void)unbind {
    glUseProgram(0);
}

- (GLuint)getId {
    return programId;
}

- (GLuint)getUniform:(NSString *)name {
    for (ProgramUniform *uniform in uniforms) {
        if ([[uniform getName] isEqualToString:name]) {
            return [uniform getId];
        }
    }
    
    GLuint location = glGetUniformLocation(programId, name.UTF8String);
    ProgramUniform *uniform = [[ProgramUniform alloc] initWithName:name uniformId:location];
    [uniforms addObject:uniform];
    return [[uniforms lastObject] getId];
}

- (void)set1i:(int)value uniformName:(NSString *)name {
    glUniform1i([self getUniform:name], value);
}

- (void)set1f:(float)value uniformName:(NSString *)name {
    glUniform1f([self getUniform:name], value);
}

- (void)set2f:(float)f1 f2:(float)f2 uniformName:(NSString *)name {
    glUniform2f([self getUniform:name], f1, f2);
}

- (void)set3f:(float)f1 f2:(float)f2 f3:(float)f3 uniformName:(NSString *)name {
    glUniform3f([self getUniform:name], f1, f2, f3);
}

- (void)set4f:(float)f1 f2:(float)f2 f3:(float)f3 f4:(float)f4 uniformName:(NSString *)name {
    glUniform4f([self getUniform:name], f1, f2, f3, f4);
}

- (void)set2fv:(GLfloat *)value uniformName:(NSString *)name {
    glUniform2fv([self getUniform:name], 1, value);
}

- (void)set3fv:(GLfloat *)value uniformName:(NSString *)name {
    glUniform3fv([self getUniform:name], 1, value);
}

- (void)set4fv:(GLfloat *)value uniformName:(NSString *)name {
    glUniform4fv([self getUniform:name], 1, value);
}

- (void)set3fvm:(GLfloat *)value uniformName:(NSString *)name {
    glUniformMatrix3fv([self getUniform:name], 1, 0, value);
}

- (void)set4fvm:(GLfloat *)value uniformName:(NSString *)name {
    glUniformMatrix4fv([self getUniform:name], 1, 0, value);
}

@end
