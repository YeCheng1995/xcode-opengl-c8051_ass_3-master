//
//  Engine.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Renderer/Renderer.h"
#import "Renderer/Camera.h"
#import "GameObject.h"

@interface Engine : NSObject {
    Renderer *renderer;
}

- (void)initView:(GLKView *)view;

- (Renderer *)getRenderer;

- (void)renderGameObject:(GameObject *)gameObject;

@end
