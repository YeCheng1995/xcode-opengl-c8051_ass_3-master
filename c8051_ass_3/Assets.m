//
//  Assets.m
//  c8051_ass_3
//
//  Created by Choy on 2019-04-12.
//  Copyright © 2019 Choy. All rights reserved.
//

#import "Assets.h"

@implementation Assets

- (id)init {
    if (self == [super init]) {
        cachedMeshes = [NSMutableDictionary dictionary];
        cachedTextures = [NSMutableDictionary dictionary];
    }
    return self;
}

- (Mesh *)getMeshByKey:(NSString *)key {
    return [[cachedMeshes objectForKey:key] copy];
}

- (Texture *)getTextureByKey:(NSString *)key {
    return [cachedTextures objectForKey:key];
}

- (void)setMesh:(Mesh *)mesh forKey:(NSString *)key {
	[mesh setup];
    [cachedMeshes setObject:mesh forKey:key];
}

- (void)setTexture:(Texture *)texture forKey:(NSString *)key {
    [cachedTextures setObject:texture forKey:key];
}

@end
