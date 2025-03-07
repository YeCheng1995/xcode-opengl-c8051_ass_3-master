//
//  Texture.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Texture.h"
#import "../Log.h"

@implementation Texture

- (id)initWithFilename:(NSString *)filename {
	return [self initWithFilename:filename TYPE:@"texture_diffuse"];
}

- (id)initWithFilename:(NSString *)filename TYPE:(NSString *)TYPE {
    if (self == [super init]) {
        CGImageRef imageRef = [UIImage imageNamed:filename].CGImage;
        if (!imageRef) {
            [Log f:@"Failed to load the image."];
            self = nil;
            return self;
        }
        
        width = CGImageGetWidth(imageRef);
        height = CGImageGetHeight(imageRef);
        
        GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        
        CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), imageRef);
        CGContextRelease(spriteContext);
        
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        glGenTextures(1, &textureId);
        glBindTexture(GL_TEXTURE_2D, textureId);
        
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        
        free(spriteData);
		
		type = TYPE;
    }
    return self;
}

- (void)dealloc {
    if (textureId) {
        glDeleteTextures(1, &textureId);
        textureId = 0;
    }
}

- (GLuint)getId {
	return textureId;
}

- (NSString *)getType {
	return type;
}

- (size_t)getWidth {
	return width;
}

- (size_t)getHeight {
	return height;
}

@end
