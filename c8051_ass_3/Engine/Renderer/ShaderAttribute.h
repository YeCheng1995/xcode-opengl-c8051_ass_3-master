//
//  ShaderAttribute.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderAttribute : NSObject {
    NSString *name;
    GLuint attributeId;
}

- (id)initWithName:(NSString *)NAME attributeId:(GLuint)ATTRIBUTEID;

- (NSString *)getName;
- (GLuint)getId;

@end
