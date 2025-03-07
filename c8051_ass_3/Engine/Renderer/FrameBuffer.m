//
//  FrameBuffer.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "FrameBuffer.h"

@implementation FrameBuffer

- (void)dealloc {
    if (framebufferId) {
        glDeleteFramebuffers(1, &framebufferId);
        framebufferId = 0;
    }
    
    if (colourRenderbuffer) {
        glDeleteRenderbuffers(1, &colourRenderbuffer);
        colourRenderbuffer = 0;
    }
    
    if (textureId) {
        glDeleteTextures(1, &textureId);
        textureId = 0;
    }
    
    if (depthRenderbuffer) {
        glDeleteRenderbuffers(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)setWidth:(GLint)width height:(GLint)height {
	// generate fbo
    glGenFramebuffers(1, &framebufferId);
    // generate texture
    glGenTextures(1, &textureId);
    // generate render buffer
    glGenRenderbuffers(1, &colourRenderbuffer);
    // bind frame buffer
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferId);
    // bind texture
    glBindTexture(GL_TEXTURE_2D, textureId);
    // define texture parameters
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // bind render buffer and define buffer dimension
    glBindRenderbuffer(GL_RENDERBUFFER, colourRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
    // attach texture fbo color attachment
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textureId, 0);
    // attach render buffer to depth attachment
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, colourRenderbuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", status);
    }
    // done creating the fbo
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindRenderbuffer(GL_RENDERBUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)bind {
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
    glBindFramebuffer(GL_FRAMEBUFFER, framebufferId);
}

- (void)unbind {
	glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
}

@end
