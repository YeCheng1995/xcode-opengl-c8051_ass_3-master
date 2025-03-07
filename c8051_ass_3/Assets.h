//
//  Assets.h
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Engine/Renderer/Mesh.h"
#import "Engine/Renderer/Texture.h"

@interface Assets : NSObject {
    NSMutableDictionary<NSString *, Mesh *> *cachedMeshes;
    NSMutableDictionary<NSString *, Texture *> *cachedTextures;
}

- (Mesh *)getMeshByKey:(NSString *)key;
- (Texture *)getTextureByKey:(NSString *)key;

- (void)setMesh:(Mesh *)mesh forKey:(NSString *)key;
- (void)setTexture:(Texture *)texture forKey:(NSString *)key;

@end
