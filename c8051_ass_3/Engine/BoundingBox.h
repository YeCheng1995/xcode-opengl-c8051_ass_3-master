//
//  BoundingBox.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface BoundingBox : NSObject {
    GLKVector2 position;
    GLKVector2 size;
    GLboolean enabled;
}

- (id)initWithPosition:(GLKVector2)POSITION;
- (id)initWithPosition:(GLKVector2)POSITION size:(GLKVector2)SIZE;

- (bool)intersectsWithBoundingBox:(BoundingBox *)boundingBox;

- (GLKVector2)getPosition;
- (GLKVector2)getSize;
- (GLboolean)getEnabled;

- (void)setPosition:(GLKVector2)POSITION;
- (void)setSize:(GLKVector2)SIZE;
- (void)setEnabled:(GLboolean)ENABLED;

@end
