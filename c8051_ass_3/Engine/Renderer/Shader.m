//
//  Shader.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Shader.h"
#import "../Log.h"

@implementation Shader

- (void)printInfoLog {
    GLsizei logLen = 0;
    GLsizei charsWritten = 0;
    GLchar *message;
    
    glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &logLen);
    
    if (logLen > 0) {
        message = (GLchar *)malloc(logLen);
        glGetShaderInfoLog(shaderId, logLen, &charsWritten, message);
        [Log f:[NSString stringWithUTF8String:message]];
        free(message);
    }
}

- (id)initWithFilename:(NSString *)filename shaderType:(GLenum)shaderType {
    if (self == [super init]) {
        shaderId = glCreateShader(shaderType);
        const char *shaderSource = [[NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil] UTF8String];
        glShaderSource(shaderId, 1, &shaderSource, NULL);
        [self compile];
    }
    return self;
}

- (void)compile {
    GLsizei success;
    
    glCompileShader(shaderId);
    
    glGetShaderiv(shaderId, GL_COMPILE_STATUS, &success);
    
    if (success == GL_FALSE) {
        [self printInfoLog];
    }
}

- (GLuint)getId {
    return shaderId;
}

@end
