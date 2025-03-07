//
//  FrameBuffer.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface FrameBuffer : NSObject {
	GLuint textureId;
	GLint oldFBO;
	GLuint framebufferId;
	GLuint colourRenderbuffer;
	GLuint depthRenderbuffer;
}

- (void)setWidth:(GLint)width height:(GLint)height;
- (void)bind;
- (void)unbind;

@end
