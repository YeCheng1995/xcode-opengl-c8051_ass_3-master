//
//  ProgramUniform.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ProgramUniform : NSObject {
    NSString *name;
    GLuint uniformId;
}

- (id)initWithName:(NSString *)NAME uniformId:(GLuint)UNIFORMID;

- (NSString *)getName;
- (GLuint)getId;
@end
